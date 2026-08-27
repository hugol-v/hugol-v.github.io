# Website editing and publishing workflow

This repository keeps work in progress separate from the public website:

- `source` is the working branch. Changes pushed here are saved on GitHub but are not published.
- `master` is the production branch. A push to this branch starts the GitHub Pages deployment.
- `legacy-pages` is a rollback snapshot of the former site and is not used for routine work.

GitHub Actions builds the Jekyll source and publishes the generated artifact. Do not copy or commit the `_site` directory.

## Routine workflow

### 1. Start on `source`

In GitHub Desktop, select the `source` branch, click **Fetch origin**, and pull any available changes before editing.

Command-line equivalent:

```sh
git switch source
git pull --ff-only origin source
```

### 2. Edit and preview locally

Make changes on `source`, then start the local preview from the repository directory:

```sh
bundle exec ruby scripts/generate_cv.rb
bundle exec jekyll serve
```

Open `http://localhost:4000` and review the affected pages in both light and dark modes and at narrow and wide window sizes. Stop the server with `Ctrl+C` when finished.

### CV content sources

The web CV and downloadable PDF are assembled from the same sources during every production build:

- Add publications and preprints to `_bibliography/papers.bib`. They appear on both the Publications page and the web CV. Use `status={Preprint}` or `status={Published}` for the CV badge. An entry is included by default; add `cv_show={false}` to omit it from the CV.
- Add talks and posters to `_bibliography/presentations.bib`. Use `presentationtype`, `eventtitle`, `venue`, and `location` as separate fields. They appear on both the Presentations page and the web CV.
- Keep education, teaching, service, experience, awards, and personal details in `assets/json/resume.json`. Every academic-service record must have a `subsection` such as `Organization`, `Review`, or `Volunteering`; any new value, such as `Editor`, automatically becomes another service heading.

Normal BibTeX titles are escaped safely for the PDF. If a publication or presentation title needs intentional LaTeX markup such as math, keep the regular `title` for the website and add a PDF-only `cv_title_tex` field.

Publications and presentations are sorted newest first automatically, so they should not also be copied into `resume.json`. The PDF layout lives in `cv_source/academic_cv.tex.erb`; the generated, comment-free LaTeX source is `cv_source/academic_cv.tex`, and the finished file replaces `assets/pdf/academic_cv.pdf`, which is already the CV page's download target. The download card's update month is set from the Jekyll build time.

To regenerate both files locally after editing either bibliography or `resume.json`, run:

```sh
bundle exec ruby scripts/generate_cv.rb
```

A local LaTeX installation with `latexmk` and `moderncv` is required for PDF compilation. Use `--tex-only` to update only the generated LaTeX source. On every pull request and production deployment, GitHub Actions regenerates the source, compiles the PDF, verifies it, and then builds the site.

### 3. Save work without publishing

Commit the changes to `source` and push them. This saves the work remotely but does not update the public website.

In GitHub Desktop, review the changed files, write a descriptive commit message, click **Commit to source**, and then **Push origin**.

### 4. Publish the changes

On GitHub, open a pull request with:

- base branch: `master`
- compare branch: `source`

Wait for the **Build site** check to pass. Review the pull request and merge it using **Create a merge commit**. Do not use squash or rebase merging for this branch pair, because preserving the branch history makes the synchronization step straightforward.

The merge pushes the source changes to `master`. The **Build and deploy site** workflow then builds the production site and deploys it to GitHub Pages automatically.

### 5. Verify the publication

Open the repository's **Actions** tab and confirm that both **Build site** and **Deploy site** completed successfully. Then check the public homepage and the pages affected by the change. If an old stylesheet briefly appears, perform a hard refresh before diagnosing the deployment.

### 6. Synchronize `source`

After publishing, bring the merge commit from `master` back into `source` so that the branches share the same history.

In GitHub Desktop:

1. Switch to `master`, fetch, and pull the merged commit.
2. Switch back to `source`.
3. Choose **Branch → Merge into current branch**, select `master`, and complete the merge.
4. Push `source`.

Command-line equivalent:

```sh
git fetch origin
git switch source
git merge --ff-only origin/master
git push origin source
```

## If a deployment fails

A failed build does not require copying `_site` or changing branches manually. Read the failed step in GitHub Actions, fix the problem on `source`, preview it locally, and publish the correction through another pull request. For an urgent rollback, revert the relevant production merge and let the workflow redeploy the previous source state.
