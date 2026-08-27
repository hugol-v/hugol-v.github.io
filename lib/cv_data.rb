# frozen_string_literal: true

require "bibtex"
require "date"
require "latex/decode"

module CvData
  class Error < StandardError; end

  class Repository
    PUBLICATIONS_PATH = "_bibliography/papers.bib"
    PRESENTATIONS_PATH = "_bibliography/presentations.bib"
    RESUME_PATH = "assets/json/resume.json"
    SOURCE_PATHS = [PUBLICATIONS_PATH, PRESENTATIONS_PATH, RESUME_PATH].freeze
    FALSE_VALUES = %w[false no 0 off].freeze
    TRUE_VALUES = %w[true yes 1 on].freeze
    THESIS_TYPES = %w[thesis mastersthesis phdthesis].freeze
    PROCEEDINGS_TYPES = %w[inproceedings incollection conference].freeze

    def initialize(root:, scholar_config: {})
      @root = File.expand_path(root.to_s)
      @scholar_config = scholar_config || {}
    end

    def publications
      entries(PUBLICATIONS_PATH)
        .each_with_index
        .filter_map do |entry, source_order|
          next unless shown_on_cv?(entry, PUBLICATIONS_PATH)

          validate_entry!(entry, PUBLICATIONS_PATH)
          names = author_names(entry)
          venue = publication_venue(entry)
          validate_publication!(entry, names, venue)
          {
            "key" => entry.key.to_s,
            "type" => entry.type.to_s.downcase,
            "name" => field(entry, :title),
            "title_tex" => raw_field(entry, :cv_title_tex),
            "publisher" => venue,
            "releaseDate" => field(entry, :year),
            "authors" => sentence_join(names.map { |name| name["display"] }),
            "author_names" => names,
            "url" => publication_url(entry),
            "status" => humanize(field(entry, :status)),
            "journal" => field(entry, :journal),
            "volume" => field(entry, :volume),
            "number" => field(entry, :number),
            "pages" => field(entry, :pages),
            "arxiv" => arxiv_identifier(entry),
            "_sort_year" => numeric_field(entry, :year),
            "_sort_month" => month_number(entry),
            "_source_order" => source_order
          }
        end
        .sort_by { |item| [-item["_sort_year"], -item["_sort_month"], item["_source_order"]] }
        .each { |item| remove_sort_fields(item) }
    end

    def presentations
      entries(PRESENTATIONS_PATH)
        .each_with_index
        .filter_map do |entry, source_order|
          next unless shown_on_cv?(entry, PRESENTATIONS_PATH)

          validate_entry!(entry, PRESENTATIONS_PATH)
          event_title = field(entry, :eventtitle)
          venue = field(entry, :venue)
          location = field(entry, :location)
          event_title = field(entry, :note) if [event_title, venue, location].all?(&:empty?)
          validate_presentation!(entry, event_title, venue, location)

          {
            "key" => entry.key.to_s,
            "name" => field(entry, :title),
            "title_tex" => raw_field(entry, :cv_title_tex),
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

    def validate_resume!(resume)
      raise Error, "#{RESUME_PATH} was not loaded" unless resume.is_a?(Hash)

      service = resume["service"]
      raise Error, "#{RESUME_PATH} must contain a service array" unless service.is_a?(Array)

      service.each_with_index do |item, index|
        subsection = item.is_a?(Hash) ? item["subsection"].to_s.strip : ""
        next unless subsection.empty?

        raise Error, "#{RESUME_PATH} service item #{index + 1} is missing subsection"
      end
    end

    private

    def entries(relative_path)
      path = File.join(@root, relative_path)
      raise Error, "could not find #{relative_path}" unless File.file?(path)

      bibliography = BibTeX.open(path)
      raise Error, "could not parse #{relative_path}" if bibliography.errors?

      replace_strings = @scholar_config.fetch("replace_strings", true)
      bibliography.replace_strings if replace_strings
      bibliography.join if @scholar_config.fetch("join_strings", true) && replace_strings
      bibliography.entries.values
    end

    def shown_on_cv?(entry, relative_path)
      value = raw_field(entry, :cv_show)
      return true if value.empty?

      normalized = value.downcase
      return false if FALSE_VALUES.include?(normalized)
      return true if TRUE_VALUES.include?(normalized)

      raise Error, "#{relative_path} entry #{entry.key} has invalid cv_show=#{value.inspect}"
    end

    def validate_entry!(entry, relative_path)
      %i[title year].each do |required_field|
        next unless field(entry, required_field).empty?

        raise Error, "#{relative_path} entry #{entry.key} is missing #{required_field}"
      end
    end

    def validate_publication!(entry, names, venue)
      raise Error, "#{PUBLICATIONS_PATH} entry #{entry.key} is missing author" if names.empty?
      raise Error, "#{PUBLICATIONS_PATH} entry #{entry.key} has no usable publication venue" if venue.empty?
    end

    def validate_presentation!(entry, event_title, venue, location)
      if field(entry, :presentationtype).empty?
        raise Error, "#{PRESENTATIONS_PATH} entry #{entry.key} is missing presentationtype"
      end

      return unless [event_title, venue, location].all?(&:empty?)

      raise Error, "#{PRESENTATIONS_PATH} entry #{entry.key} has no event or location"
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

    def author_names(entry)
      entry.authors.each.map do |author|
        prefix = decode(author.prefix.to_s)
        last = decode(author.last.to_s)
        suffix = decode(author.suffix.to_s)
        {
          "first" => decode(author.first.to_s),
          "last" => last,
          "prefix" => prefix,
          "suffix" => suffix,
          "family" => [prefix, last].reject(&:empty?).join(" "),
          "display" => decode(author.display_order)
        }
      end
    end

    def sentence_join(values)
      return "" if values.empty?
      return values.first if values.one?
      return values.join(" and ") if values.length == 2

      "#{values[0...-1].join(', ')}, and #{values.last}"
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
  end
end
