# marekduciuc.github.io

Personal CV and case studies, served by GitHub Pages from `main` (static HTML, no build). The Google OAuth pages for the personal client "claudecode" live in `google/`.

## Adding a case study

1. Copy an existing page in `case-studies/` to `case-studies/<slug>.html` and replace the content. Keep the breadcrumb (`Marek Duciuc` → `/`, `Case studies` → `/case-studies/`), the canonical link and the JSON-LD `Article`.
2. Add a teaser (`<article class="teaser">`) to `case-studies/index.html` and an entry to its JSON-LD `itemListElement`.
3. The home page (`index.html`) shows exactly three teasers. Swap one only if the new case study should be featured there.
4. Add the page to `sitemap.xml`, `llms.txt` and the case study list in `cv.md`.
5. Only facts that can be checked: no invented numbers, no client names unless allowed.
