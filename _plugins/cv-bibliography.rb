# frozen_string_literal: true

require_relative "../lib/cv_data"

module Jekyll
  # Populates the web CV from the same parsed data used by the PDF generator.
  class CvBibliographyGenerator < Generator
    safe true
    priority :high

    def generate(site)
      resume = site.data["resume"]
      repository = CvData::Repository.new(
        root: site.source,
        scholar_config: site.config.fetch("scholar", {})
      )

      repository.validate_resume!(resume)
      resume["publications"] = repository.publications
      resume["presentations"] = repository.presentations
      resume["meta"] ||= {}
      resume["meta"]["lastUpdated"] = site.time.strftime("%B %Y")
      register_cv_dependencies(site)
    rescue CvData::Error => error
      raise Jekyll::Errors::FatalException, "CV bibliography: #{error.message}"
    rescue Jekyll::Errors::FatalException
      raise
    rescue StandardError => error
      raise Jekyll::Errors::FatalException,
            "CV bibliography: could not build the bibliography-backed CV: #{error.message}"
    end

    private

    def register_cv_dependencies(site)
      dependencies = CvData::Repository::SOURCE_PATHS.map { |path| site.in_source_dir(path) }
      site.pages.each do |page|
        next unless page.data["layout"] == "cv"

        source = site.in_source_dir(page.path)
        dependencies.each { |dependency| site.regenerator.add_dependency(source, dependency) }
      end
    end
  end
end
