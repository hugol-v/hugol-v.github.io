$(document).ready(function () {
  // Add accessible toggle functionality to publication details.
  function togglePublicationDetail(buttonSelector, detailSelector) {
    $(buttonSelector).click(function () {
      const button = $(this);
      const publication = button.closest(".publication-content");
      const detail = publication.find(detailSelector).first();
      const shouldOpen = !detail.hasClass("open");

      publication.find(".publication-detail.open").removeClass("open").attr("aria-hidden", "true");
      publication.find(".links button[aria-expanded='true']").attr("aria-expanded", "false");

      if (shouldOpen) {
        detail.addClass("open").attr("aria-hidden", "false");
        button.attr("aria-expanded", "true");
      }
    });
  }

  togglePublicationDetail(".links button.abstract", ".abstract.publication-detail");
  togglePublicationDetail(".links button.award", ".award.publication-detail");
  togglePublicationDetail(".links button.bibtex", ".bibtex.publication-detail");
  togglePublicationDetail(".links button.video-toggle", ".video.publication-detail");

  $(".author-list-expand").click(function () {
    const button = $(this);
    const summary = button.closest(".author-list-summary");
    const additionalAuthors = summary.next(".additional-authors");

    button.attr("aria-expanded", "true");
    summary.prop("hidden", true);
    additionalAuthors.prop("hidden", false).attr("aria-hidden", "false");
    additionalAuthors.find(".author-list-collapse").trigger("focus");
  });

  $(".author-list-collapse").click(function () {
    const button = $(this);
    const additionalAuthors = button.closest(".additional-authors");
    const summary = additionalAuthors.prev(".author-list-summary");
    const expandButton = summary.find(".author-list-expand");

    additionalAuthors.prop("hidden", true).attr("aria-hidden", "true");
    summary.prop("hidden", false);
    expandButton.attr("aria-expanded", "false").trigger("focus");
  });

  $("a").removeClass("waves-effect waves-light");

  // bootstrap-toc
  if ($("#toc-sidebar").length) {
    // remove related publications years from the TOC
    $(".publications h2").each(function () {
      $(this).attr("data-toc-skip", "");
    });
    var navSelector = "#toc-sidebar";
    var $myNav = $(navSelector);
    Toc.init($myNav);
    $("body").scrollspy({
      target: navSelector,
    });
  }

  // add css to jupyter notebooks
  const cssLink = document.createElement("link");
  cssLink.href = "../css/jupyter.css";
  cssLink.rel = "stylesheet";
  cssLink.type = "text/css";

  let theme = determineComputedTheme();

  $(".jupyter-notebook-iframe-container iframe").each(function () {
    $(this).contents().find("head").append(cssLink);

    if (theme == "dark") {
      $(this).bind("load", function () {
        $(this).contents().find("body").attr({
          "data-jp-theme-light": "false",
          "data-jp-theme-name": "JupyterLab Dark",
        });
      });
    }
  });
});
