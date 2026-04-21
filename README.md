# Open Mic Odyssey Website

Static HTML/CSS website with JavaScript, hosted on GitHub Pages, for the Open Mic Odyssey movie.

The website is authored on the `build` branch, published by GitHub Actions to the `main` branch, and served at [https://openmicodyssey.com](https://openmicodyssey.com).

This repository is the static-site counterpart to the richer Flask implementation in `80-movie/website`. The 81-movie site keeps the same information architecture and content model, but ships as static pages under `build/` for GitHub Pages hosting.

## Tech Stack

We rely on open source technologies and established web standards to create a seamless and engaging user experience.

### Delivery

- HTML/CSS/JavaScript
- GitHub Pages for hosting
- GitHub Actions for CI/CD

### Frontend

- Responsive design using CSS Flexbox and Grid
- Interactive elements with JavaScript
- SEO optimization for better search engine visibility
- JSON-LD for structured data, rich snippets and Knowledge Graph integration for AEO
- Accessibility features to ensure the website is usable by everyone, including those with disabilities

## Static Page Structure

- `build/index.html`: Overview landing page for `/` with the trailer, primary CTAs, and quick story teaser.
- `build/film.html`: Detailed film page for `/film` with synopsis, credits, and showtimes/access.
- `build/gallery.html`: Gallery page for `/gallery` with stills, poster art, and behind-the-scenes frames.
- `build/support.html`: Public support hub for `/support` with official channels and lightweight support actions.
- `build/patreon.html`: Dedicated membership conversion page for `/patreon`.
- `build/watch.html`: Static compatibility redirect to `index.html#trailer`.
- `build/credits.html`: Static compatibility redirect to `film.html#credits`.
- `build/about.html`: Legacy alias redirect to `film.html#synopsis`.
- `build/css/site.css`: Shared site styles.
- `build/js/scripts.js`: Shared client-side behavior.

## Route Mapping From 80-movie

The static export mirrors the current 80-movie page set:

- `/` -> `build/index.html`
- `/film` -> `build/film.html`
- `/gallery` -> `build/gallery.html`
- `/support` -> `build/support.html`
- `/patreon` -> `build/patreon.html`
- `/watch` -> `build/watch.html` redirecting to `/#trailer`
- `/credits` -> `build/credits.html` redirecting to `/film#credits`

`contact.html` is intentionally not part of the current parity set because the source site does not expose a standalone contact workflow yet.

## Content Model

The static pages currently mirror these 80-movie content areas:

- title, tagline, synopsis, genre, runtime, and release messaging
- trailer metadata and first-view CTA flow
- gallery cards with category, image, alt text, and caption
- support/social links and campaign updates
- supporter benefits and suggested Patreon tiers

## Deployment Flow

The publishing contract remains static-first:

1. Make content and layout changes on the `build` branch.
2. Keep deployable files under `build/`.
3. Run GitHub Actions to publish the contents of `build/` to the `main` branch.
4. Serve the published `main` branch via GitHub Pages.
