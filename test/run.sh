#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-build}"
ENABLE_NETWORK_LINK_CHECKS="${ENABLE_NETWORK_LINK_CHECKS:-0}"

fail() {
  echo "Test failed: $1" >&2
  exit 1
}

require_file() {
  local path="$1"
  [ -f "$path" ] || fail "missing file: $path"
}

require_text() {
  local path="$1"
  local needle="$2"
  grep -Fq "$needle" "$path" || fail "$path does not contain required text: $needle"
}

check_anchor() {
  local path="$1"
  local fragment="$2"
  grep -Eq "id=\"$fragment\"" "$path" || fail "$path is missing anchor id: $fragment"
}

check_external_url() {
  local url="$1"

  case "$url" in
    https://*) ;;
    http://*) fail "external URL must use https: $url" ;;
    *) fail "external URL is not an absolute https URL: $url" ;;
  esac

  if [ "$ENABLE_NETWORK_LINK_CHECKS" = "1" ]; then
    local status
    status=$(curl --silent --show-error --location --output /dev/null --write-out "%{http_code}" --max-time 20 "$url") || fail "network request failed for: $url"
    case "$status" in
      2*|3*) ;;
      *) fail "external URL returned HTTP $status: $url" ;;
    esac
  fi
}

extract_hrefs() {
  local path="$1"
  grep -oE 'href="[^"]+"' "$path" | sed -E 's/^href="(.*)"$/\1/' | sort -u
}

PRIMARY_PAGES=(index film gallery support patreon)
REDIRECT_PAGES=(watch credits about)

require_file "$ROOT_DIR/css/site.css"
require_file "$ROOT_DIR/js/scripts.js"

for page in "${PRIMARY_PAGES[@]}"; do
  file="$ROOT_DIR/$page.html"
  require_file "$file"

  require_text "$file" "<!doctype html>"
  require_text "$file" "<html lang=\"en\">"
  require_text "$file" "<head>"
  require_text "$file" "</head>"
  require_text "$file" "<body"
  require_text "$file" "</body>"
  require_text "$file" "</html>"

  require_text "$file" "<title>"
  require_text "$file" "<meta name=\"description\""
  require_text "$file" "<link rel=\"canonical\""
  require_text "$file" "<meta property=\"og:title\""
  require_text "$file" "<meta property=\"og:description\""
  require_text "$file" "<script type=\"application/ld+json\">"

  require_text "$file" "class=\"skip-link\""
  require_text "$file" "href=\"#main-content\""
  require_text "$file" "<nav class=\"nav\" aria-label=\"Main navigation\">"
  require_text "$file" "aria-controls=\"nav-links\""
  require_text "$file" "aria-expanded=\"false\""
  require_text "$file" "aria-label=\"Open navigation menu\""
  require_text "$file" "<main id=\"main-content\" tabindex=\"-1\">"
done

require_text "$ROOT_DIR/index.html" "<iframe"
require_text "$ROOT_DIR/index.html" "title=\"Open Mic Odyssey official trailer\""

if grep -Eq '<img [^>]*>' "$ROOT_DIR/gallery.html"; then
  while IFS= read -r image_tag; do
    printf '%s' "$image_tag" | grep -Eq 'alt="[^"]+"' || fail "gallery image missing non-empty alt text"
  done < <(grep -oE '<img [^>]*>' "$ROOT_DIR/gallery.html")
fi

for page in "${REDIRECT_PAGES[@]}"; do
  file="$ROOT_DIR/$page.html"
  require_file "$file"
  require_text "$file" "http-equiv=\"refresh\""
done

declare -a external_urls=()

while IFS= read -r html_file; do
  [ -n "$html_file" ] || continue

  while IFS= read -r href; do
    [ -n "$href" ] || continue

    case "$href" in
      mailto:*|tel:*|javascript:*)
        continue
        ;;
      https://*|http://*)
        external_urls+=("$href")
        ;;
      \#*)
        check_anchor "$html_file" "${href#\#}"
        ;;
      *)
        target_path="$href"
        fragment=""

        if [[ "$href" == *#* ]]; then
          target_path="${href%%#*}"
          fragment="${href#*#}"
        fi

        if [ -n "$target_path" ]; then
          resolved_path="$ROOT_DIR/$target_path"
          require_file "$resolved_path"
        else
          resolved_path="$html_file"
        fi

        if [ -n "$fragment" ]; then
          check_anchor "$resolved_path" "$fragment"
        fi
        ;;
    esac
  done < <(extract_hrefs "$html_file")
done < <(find "$ROOT_DIR" -maxdepth 1 -name '*.html' -type f | sort)

if [ "${#external_urls[@]}" -gt 0 ]; then
  while IFS= read -r url; do
    [ -n "$url" ] || continue
    check_external_url "$url"
  done < <(printf '%s\n' "${external_urls[@]}" | sort -u)
fi

echo "Static site tests passed for $ROOT_DIR"