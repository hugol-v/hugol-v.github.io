#!/usr/bin/env ruby
# frozen_string_literal: true

require "erb"
require "fileutils"
require "json"
require "open3"
require "optparse"
require "yaml"
require_relative "../lib/cv_data"

class AcademicCvGenerator
  ROOT = File.expand_path("..", __dir__)
  RESUME_PATH = File.join(ROOT, CvData::Repository::RESUME_PATH)
  CONFIG_PATH = File.join(ROOT, "_config.yml")
  TEMPLATE_PATH = File.join(ROOT, "cv_source", "academic_cv.tex.erb")
  TEX_PATH = File.join(ROOT, "cv_source", "academic_cv.tex")
  PDF_PATH = File.join(ROOT, "assets", "pdf", "academic_cv.pdf")
  BUILD_ROOT = File.join(ROOT, "tmp", "pdfs")

  LATEX_ESCAPES = {
    "\\" => "\\textbackslash{}",
    "{" => "\\{",
    "}" => "\\}",
    "$" => "\\$",
    "&" => "\\&",
    "#" => "\\#",
    "_" => "\\_",
    "%" => "\\%",
    "~" => "\\textasciitilde{}",
    "^" => "\\textasciicircum{}"
  }.freeze

  REQUIRED_ARRAYS = %w[interests education teaching service work awards].freeze
  REQUIRED_BASICS = %w[name firstName lastName affiliation department institution email url location].freeze

  def initialize(tex_only: false)
    @tex_only = tex_only
  end

  def run
    resume = JSON.parse(File.read(RESUME_PATH, encoding: "UTF-8"))
    site_config = YAML.safe_load(File.read(CONFIG_PATH, encoding: "UTF-8"), aliases: true) || {}
    repository = CvData::Repository.new(root: ROOT, scholar_config: site_config.fetch("scholar", {}))
    repository.validate_resume!(resume)
    validate_resume!(resume)

    resume["publications"] = repository.publications
    resume["presentations"] = repository.presentations
    prepare_view_data(resume)

    template = File.read(TEMPLATE_PATH, encoding: "UTF-8")
    rendered = ERB.new(template, trim_mode: "-").result(binding)
    validate_rendered_tex!(rendered)
    atomic_write(TEX_PATH, rendered)
    puts "Generated #{relative(TEX_PATH)}"

    compile_pdf unless @tex_only
  rescue CvData::Error, JSON::ParserError, KeyError, Psych::SyntaxError => error
    warn "CV generation failed: #{error.message}"
    exit 1
  end

  private

  def validate_resume!(resume)
    basics = resume["basics"]
    raise CvData::Error, "resume.json must contain a basics object" unless basics.is_a?(Hash)

    REQUIRED_BASICS.each do |field|
      raise CvData::Error, "resume.json basics.#{field} is missing" if basics[field].nil? || basics[field] == ""
    end

    REQUIRED_ARRAYS.each do |field|
      raise CvData::Error, "resume.json must contain a #{field} array" unless resume[field].is_a?(Array)
    end
  end

  def prepare_view_data(resume)
    @resume = resume
    @basics = resume.fetch("basics")
    @basics_name = @basics.fetch("name")
    @first_name = @basics.fetch("firstName")
    @last_name = @basics.fetch("lastName")
    @affiliation_lines = [@basics.fetch("department"), @basics.fetch("institution")]
    location = @basics.fetch("location")
    @location = [location["city"], location["region"], location["country"]].compact.reject(&:empty?).join(", ")
    @homepage = @basics.fetch("url").sub(%r{\Ahttps?://}i, "").sub(%r{/\z}, "")
  end

  def tex(value)
    value.to_s.gsub(/[\\{}$&#_%~^]/) { |character| LATEX_ESCAPES.fetch(character) }
  end

  def tex_date(value)
    normalized = value.to_s.tr("–—", "--")
    normalized = normalized.gsub(/(?<=\d{4})-(?=\d{4}|Present)/, "--")
    tex(normalized)
  end

  def itemize(items)
    values = Array(items).reject { |item| item.to_s.strip.empty? }
    return "{}" if values.empty?

    body = values.map { |item| "    \\item #{tex(item)}" }.join("\n")
    "{\\begin{itemize}\n#{body}\n\\end{itemize}}"
  end

  def interests_sentence
    values = @resume.fetch("interests").map(&:to_s)
    values = values.each_with_index.map do |interest, index|
      index.zero? ? interest : interest.sub(/\A./) { |first| first.downcase }
    end
    sentence = if values.length < 2
                 values.first.to_s
               else
                 "#{values[0...-1].join(', ')}, and #{values.last}"
               end
    "#{tex(sentence)}."
  end

  def author_initials(first_names)
    first_names.to_s.split(/\s+/).map do |part|
      part.split("-").map { |component| component.empty? ? "" : "#{component[0]}." }.join("-")
    end.join(" ")
  end

  def publication_authors(publication)
    formatted = publication.fetch("author_names").map do |name|
      family = name.fetch("family")
      suffix = name.fetch("suffix")
      label = "#{tex(family)}, #{tex(author_initials(name.fetch('first')))}"
      label = "#{label}, #{tex(suffix)}" unless suffix.empty?
      name.fetch("display") == @basics_name ? "\\textbf{#{label}}" : label
    end

    case formatted.length
    when 0 then ""
    when 1 then formatted.first
    when 2 then "#{formatted.first}, \\& #{formatted.last}"
    else "#{formatted[0...-1].join(', ')}, \\& #{formatted.last}"
    end
  end

  def publication_venue(publication)
    journal = publication.fetch("journal")
    if journal.empty?
      arxiv = publication.fetch("arxiv")
      label = publication.fetch("status") == "Preprint" && !arxiv.empty? ? "arXiv:#{arxiv}" : publication.fetch("publisher")
      "\\textit{#{tex(label)}}"
    else
      volume = tex(publication.fetch("volume"))
      number = tex(publication.fetch("number"))
      issue = number.empty? ? volume : "#{volume}(#{number})"
      parts = ["\\textit{#{tex(journal)}}", issue, tex(publication.fetch("pages"))].reject(&:empty?)
      parts.join(", ")
    end
  end

  def publication_item(publication)
    authors = publication_authors(publication)
    year = tex_date(publication.fetch("releaseDate"))
    title = publication.fetch("title_tex")
    title = tex(publication.fetch("name")) if title.empty?
    venue = publication_venue(publication)
    status = publication.fetch("status")
    status_note = status == "Published" || status.empty? ? "" : " (#{tex(status)})"
    "#{authors} (#{year}). ``#{title}.'' #{venue}#{status_note}."
  end

  def presentation_item(presentation)
    title_text = presentation.fetch("title_tex")
    title_text = tex(presentation.fetch("name")) if title_text.empty?
    title = "\\textbf{``#{title_text},''}"
    type = presentation.fetch("type").to_s.sub(/\A./) { |first| first.downcase }
    details = []
    details << tex(type) unless type.empty?
    event_title = presentation.fetch("eventtitle")
    details << "\\textit{#{tex(event_title)}}" unless event_title.empty?
    venue = presentation.fetch("venue")
    details << tex(venue) unless venue.empty?
    location = presentation.fetch("location")
    details << tex(location) unless location.empty?
    details << tex_date(presentation.fetch("date"))
    "#{title} #{details.join(', ')}."
  end

  def compact_semester(value)
    semester = value.to_s
    return tex_date(semester) unless semester.include?(",")

    compact = semester
                   .gsub(/\bFall (?=\d{4})/, "F")
                   .gsub(/\bWinter (?=\d{4})/, "W")
                   .gsub(/\bSpring (?=\d{4})/, "S")
    tex_date(compact)
  end

  def service_groups
    @resume.fetch("service").group_by { |item| item.fetch("subsection") }
  end

  def validate_rendered_tex!(rendered)
    raise CvData::Error, "generated TeX still contains a LaTeX comment" if rendered.match?(/(?<!\\)%/)
    raise CvData::Error, "generated TeX contains an unresolved template expression" if rendered.include?("<%")
  end

  def compile_pdf
    FileUtils.mkdir_p(BUILD_ROOT)
    build_dir = File.join(BUILD_ROOT, "academic_cv_build")
    FileUtils.mkdir_p(build_dir)

    command = [
      ENV.fetch("LATEXMK", "latexmk"),
      "-pdf",
      "-interaction=nonstopmode",
      "-halt-on-error",
      "-file-line-error",
      "-outdir=#{build_dir}",
      TEX_PATH
    ]
    output, status = Open3.capture2e(*command, chdir: ROOT)
    unless status.success?
      warn output
      raise CvData::Error, "LaTeX compilation failed"
    end

    compiled_pdf = File.join(build_dir, "academic_cv.pdf")
    raise CvData::Error, "LaTeX compilation did not produce academic_cv.pdf" unless File.file?(compiled_pdf)

    FileUtils.mkdir_p(File.dirname(PDF_PATH))
    temporary_pdf = "#{PDF_PATH}.tmp"
    FileUtils.cp(compiled_pdf, temporary_pdf)
    FileUtils.mv(temporary_pdf, PDF_PATH, force: true)
    puts "Generated #{relative(PDF_PATH)}"
  rescue Errno::ENOENT
    raise CvData::Error, "latexmk was not found; install LaTeX or run with --tex-only"
  ensure
    FileUtils.rm_f("#{PDF_PATH}.tmp")
  end

  def atomic_write(path, content)
    FileUtils.mkdir_p(File.dirname(path))
    temporary_path = "#{path}.tmp"
    File.binwrite(temporary_path, content)
    FileUtils.mv(temporary_path, path, force: true)
  ensure
    FileUtils.rm_f(temporary_path) if temporary_path
  end

  def relative(path)
    path.delete_prefix("#{ROOT}#{File::SEPARATOR}")
  end
end

options = { tex_only: false }
OptionParser.new do |parser|
  parser.banner = "Usage: bundle exec ruby scripts/generate_cv.rb [--tex-only]"
  parser.on("--tex-only", "Generate the .tex file without compiling the PDF") { options[:tex_only] = true }
end.parse!

AcademicCvGenerator.new(**options).run
