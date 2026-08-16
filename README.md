# Hugo Latourelle-Vigeant's academic website

This repository contains the source for [hugol-v.github.io](https://hugol-v.github.io/), an academic website built with Jekyll.

## Development

Work in progress belongs on the `source` branch. To preview the site locally, run:

```sh
bundle install
bundle exec jekyll serve
```

The preview is available at `http://localhost:4000`. The generated `_site` directory is local build output and should not be committed.

## Publishing

The `master` branch is the production source branch. GitHub Actions builds it with the production configuration and deploys the generated artifact to GitHub Pages.

See [WEBSITE_WORKFLOW.md](WEBSITE_WORKFLOW.md) for the complete editing, preview, review, publication, and synchronization process.

## Content structure

- `_pages/` contains the main pages.
- `_research/`, `_misc/`, and `_news/` contain the corresponding collections.
- `_bibliography/` contains publications and presentations in BibTeX format.
- `assets/json/resume.json` supplies the abridged web CV.
- `_sass/` and `assets/css/main.scss` contain the website styling.

## Attribution

This website was originally based on the [al-folio](https://github.com/alshedivat/al-folio) academic website theme and has since been customized. The applicable MIT license and attribution are retained in [LICENSE](LICENSE).
