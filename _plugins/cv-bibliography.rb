# frozen_string_literal: true

require "bibtex"
require "date"
require "latex/decode"

module Jekyll
  # Builds the bibliography-backed sections of the web CV. resume.json remains
  # the source of truth for every other section.
  class CvBibliographyGenerator < Generator
    safe true
    priority :high

    PUBLICATIONS_PATH = "_bibliography/papers.bib"
    PRESENTATIONS_PATH = "_bibliography/presentations.bib"
    RESUME_PATH = "assets/json/resume.json"
    FALSE_VALUES = %w[false no 0 off].freeze
    TRUE_VALUES = %w[true yes 1 on].freeze
    THESIS_TYPES = %w[thesis mastersthesis phdthesis].freeze
    PROCEEDINGS_TYPES = %w[inproceedings incollection conference].freeze

    def generate(site)
      resume = site.data["resume"]
      fatal!("#{RESUME_PATH} was not loaded") unless resume.is_a?(Hash)

      validate_service!(resume["service"])
      resume["publications"] = publication_items(site)
      resume["presentations"] = presentation_items(site)
      register_cv_dependencies(site)
    rescue Jekyll::Errors::FatalException
      raise
    rescue StandardError => error
      fatal!("could not build the bibliography-backed CV: #{error.message}")
    end

    private

    def publication_items(site)
      entries(site, PUBLICATIONS_PATH)
        .each_with_index
        .filter_map do |entry, source_order|
          next unless shown_on_cv?(entry, PUBLICATIONS_PATH)

          validate_entry!(entry, PUBLICATIONS_PATH)
          {
            "key" => entry.key.to_s,
            "name" => field(entry, :title),
            "publisher" => publication_venue(entry),
            "releaseDate" => field(entry, :year),
            "authors" => author_list(entry),
            "url" => publication_url(entry),
            "status" => humanize(field(entry, :status)),
            "_sort_year" => numeric_field(entry, :year),
            "_sort_month" => month_number(entry),
            "_source_order" => source_order
          }
        end
        .sort_by { |item| [-item["_sort_year"], -item["_sort_month"], item["_source_order"]] }
        .each { |item| remove_sort_fields(item) }
    end

    def presentation_items(site)
      entries(site, PRESENTATIONS_PATH)
        .each_with_index
        .filter_map do |entry, source_order|
          next unless shown_on_cv?(entry, PRESENTATIONS_PATH)

          validate_entry!(entry, PRESENTATIONS_PATH)
          event_title = field(entry, :eventtitle)
          venue = field(entry, :venue)
          location = field(entry, :location)

          # A legacy note remains a safe fallback, but structured fields should
          # be used because event and place names may themselves contain commas.
          event_title = field(entry, :note) if [event_title, venue, location].all?(&:empty?)

          {
            "key" => entry.key.to_s,
            "name" => field(entry, :title),
            "date" => presentation_date(entry),
            "type" => field(entry, :presentationtype),
            "eventtitle" => event_title,
            "venue" => venue,
            "location" => location,
            "_sort_year" => numeric_field(entry, :year),
            "_sort_month" => month_number(entry),
            "_source_order" => source_order
          }
        end
        .sort_by { |item| [-item["_sort_year"], -item["_sort_month"], item["_source_order"]] }
        .each { |item| remove_sort_fields(item) }
    end

    def entries(site, relative_path)
      path = site.in_source_dir(relative_path)
      fatal!("could not find #{relative_path}") unless File.file?(path)

      bibliography = BibTeX.open(path)
      fatal!("could not parse #{relative_path}") if bibliography.errors?

      scholar_config = site.config.fetch("scholar", {})
      bibliography.replace_strings if scholar_config.fetch("replace_strings", true)
      bibliography.join if scholar_config.fetch("join_strings", true) && scholar_config.fetch("replace_strings", true)
      bibliography.entries.values
    end

    def shown_on_cv?(entry, relative_path)
      value = raw_field(entry, :cv_show)
      return true if value.empty?

      normalized = value.downcase
      return false if FALSE_VALUES.include?(normalized)
      return true if TRUE_VALUES.include?(normalized)

      fatal!("#{relative_path} entry #{entry.key} has invalid cv_show=#{value.inspect}")
    end

    def validate_entry!(entry, relative_path)
      %i[title year].each do |required_field|
        next unless field(entry, required_field).empty?

        fatal!("#{relative_path} entry #{entry.key} is missing #{required_field}")
      end
    end

    def validate_service!(service)
      fatal!("#{RESUME_PATH} must contain a service array") unless service.is_a?(Array)

      service.each_with_index do |item, index|
        subsection = item.is_a?(Hash) ? item["subsection"].to_s.strip : ""
        next unless subsection.empty?

        fatal!("#{RESUME_PATH} service item #{index + 1} is missing subsection")
      end
    end

    def publication_venue(entry)
      explicit = field(entry, :cv_publisher)
      return explicit unless explicit.empty?

      type = entry.type.to_s.downcase
      journal = field(entry, :journal)
      unless journal.empty?
        issue = field(entry, :volume)
        number = field(entry, :number)
        issue = "#{issue}(#{number})" unless number.empty?
        return [journal, issue, field(entry, :pages)].reject(&:empty?).join(", ")
      end

      arxiv = arxiv_identifier(entry)
      return "arXiv preprint arXiv:#{arxiv}" unless arxiv.empty?

      return field(entry, :booktitle) if PROCEEDINGS_TYPES.include?(type) && !field(entry, :booktitle).empty?

      if THESIS_TYPES.include?(type)
        institution = first_present(field(entry, :school), field(entry, :publisher))
        return institution unless institution.empty?
      end

      first_present(field(entry, :publisher), field(entry, :institution), field(entry, :abbr))
    end

    def publication_url(entry)
      explicit = first_present(raw_field(entry, :cv_url), raw_field(entry, :url))
      return explicit unless explicit.empty?

      doi = raw_field(entry, :doi)
      unless doi.empty?
        return doi if doi.match?(%r{\Ahttps?://}i)

        return "https://doi.org/#{doi}"
      end

      article = raw_field(entry, :article)
      return article unless article.empty?

      arxiv = arxiv_identifier(entry)
      return "https://arxiv.org/abs/#{arxiv}" unless arxiv.empty?

      pdf = raw_field(entry, :pdf)
      pdf.empty? ? "" : "/assets/pdf/#{pdf}"
    end

    def arxiv_identifier(entry)
      arxiv = raw_field(entry, :arxiv)
      return arxiv unless arxiv.empty? || arxiv.match?(%r{\Ahttps?://}i)

      prefix = raw_field(entry, :archiveprefix)
      eprint = raw_field(entry, :eprint)
      return "" if eprint.empty? || eprint.match?(%r{\Ahttps?://}i)
      return eprint if prefix.casecmp("arxiv").zero? || eprint.match?(%r{\A\d{4}\.\d{4,5}(?:v\d+)?\z})

      ""
    end

    def author_list(entry)
      authors = entry.authors.each.map { |author| decode(author.display_order) }
      return "" if authors.empty?
      return authors.first if authors.one?
      return authors.join(" and ") if authors.length == 2

      "#{authors[0...-1].join(', ')}, and #{authors.last}"
    end

    def presentation_date(entry)
      year = field(entry, :year)
      month = month_number(entry)
      month.positive? ? "#{Date::MONTHNAMES.fetch(month)} #{year}" : year
    end

    def month_number(entry)
      entry.month_numeric.to_i
    rescue NoMethodError, TypeError, ArgumentError
      0
    end

    def numeric_field(entry, name)
      raw_field(entry, name).to_i
    end

    def field(entry, name)
      decode(raw_field(entry, name))
    end

    def raw_field(entry, name)
      value = entry[name]
      value.nil? ? "" : value.to_s.strip
    end

    def decode(value)
      LaTeX.decode(value.to_s).to_s.strip
    end

    def humanize(value)
      value.to_s.split(/[_\s-]+/).map(&:capitalize).join(" ")
    end

    def first_present(*values)
      values.find { |value| !value.to_s.empty? }.to_s
    end

    def remove_sort_fields(item)
      item.delete("_sort_year")
      item.delete("_sort_month")
      item.delete("_source_order")
      item
    end

    def register_cv_dependencies(site)
      dependencies = [PUBLICATIONS_PATH, PRESENTATIONS_PATH, RESUME_PATH].map { |path| site.in_source_dir(path) }
      site.pages.each do |page|
        next unless page.data["layout"] == "cv"

        source = site.in_source_dir(page.path)
        dependencies.each { |dependency| site.regenerator.add_dependency(source, dependency) }
      end
    end

    def fatal!(message)
      raise Jekyll::Errors::FatalException, "CV bibliography: #{message}"
    end
  end
end
