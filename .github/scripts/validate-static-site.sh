#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-build}"

fail() {
  echo "Validation failed: $1" >&2
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

require_nonempty() {
  local path="$1"
  [ -s "$path" ] || fail "file is empty: $path"
}

require_file "$ROOT_DIR/index.html"
require_file "$ROOT_DIR/film.html"
require_file "$ROOT_DIR/media.html"
require_file "$ROOT_DIR/connect.html"
require_file "$ROOT_DIR/patreon.html"
require_file "$ROOT_DIR/css/site.css"
require_file "$ROOT_DIR/js/scripts.js"

require_nonempty "$ROOT_DIR/css/site.css"
require_nonempty "$ROOT_DIR/js/scripts.js"

for page in index film media connect patreon; do
  file="$ROOT_DIR/$page.html"
  require_text "$file" "<!doctype html>"
  require_text "$file" "<html lang=\"en\">"
  require_text "$file" "<script type=\"application/ld+json\">"
  require_text "$file" "<link rel=\"stylesheet\" href=\"css/site.css\" />"
  require_text "$file" "<script src=\"js/scripts.js\"></script>"
  require_text "$file" "<nav class=\"nav\" aria-label=\"Main navigation\">"
  require_text "$file" "<main"
  require_text "$file" "<footer class=\"site-footer\">"
done

echo "Static site validation passed for $ROOT_DIR"
