# Test Plan

This folder defines the local and CI checks for the generated static site in `build/`.

## Scope

The test plan covers four areas before commits, pull requests, and production deployment:

1. HTML validation for generated pages.
2. Link validation for internal anchors and external URLs.
3. Accessibility checks against the rendered site.
4. SEO metadata presence and correctness.

## Layout

- `test/run.ps1`
  Windows-friendly local entrypoint for all checks.
- `test/run.sh`
  POSIX entrypoint for CI and local shells.

## Implemented Checks

### HTML validation

- The current runner performs lightweight structural assertions on generated `.html` files.
- It verifies document shell markers such as `<!doctype html>`, `<html lang="en">`, `<head>`, `<body>`, `<main>`, and closing tags.
- It is designed to catch broken page shells without adding external runtime dependencies.

### Link validation

- The current runner validates all `href` targets in generated HTML.
- It checks local file targets, same-page anchors, and cross-page anchors such as `#trailer`, `#credits`, `#synopsis`, and `#tickets`.
- External URLs are validated for absolute `https` format by default.
- Optional network validation is available by setting `ENABLE_NETWORK_LINK_CHECKS=1` before running `test/run.sh`.

### Accessibility checks

- The current runner performs static accessibility assertions for shared page requirements.
- It verifies skip links, the `main-content` target, navigation labels, nav toggle state attributes, iframe titles, and non-empty gallery image alt text.
- Lighthouse CI can still be layered on later if browser-based scoring becomes necessary.

### SEO metadata checks

- The current runner verifies the required metadata markers on each primary page.
- It checks for `<title>`, meta description, canonical links, Open Graph title/description, and JSON-LD blocks.

## Planned Local Flow

1. Generate or update files under `build/`.
2. Run the static validation script already used by CI:
   - `.github/scripts/validate-static-site.sh build`
3. Run `test/run.ps1` or `test/run.sh`.
4. Fix failing HTML, link, accessibility, or SEO checks before commit.

## Planned CI Integration

The GitHub Pages workflow now adds a dedicated test step before Pages deployment that:

1. checks out the repository,
2. runs `.github/scripts/validate-static-site.sh build`,
3. runs the test entrypoint from `test/`,
4. deploys only if validation and tests pass.
