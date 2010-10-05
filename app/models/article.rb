class Article < ActiveRecord::Base
  belongs_to :domain
  before_save :create_slug
  before_save :remove_www_from_origin_url
  
  named_scope :ready, lambda {|time| {:conditions => ["text <> '' and published_at <= ?", time.utc], :order => "published_at desc"}}
  
  def process
    self.text = ""
    require 'open-uri'
    article = Nokogiri::HTML(open(origin_url)).search(domain.nokogiri_search_field).first
    if article
      article.children.each do |element|
        if element.content.present?
          content = word_processing(element.content)
        end

        if element.name == domain.paragraph_tag && content.present? && content.size > 8
          self.text << "<p>#{content}</p>"
        end
      end
      domain.nokogiri_time_fields.split(",").each do |field|
        time_field = Nokogiri::HTML(open(origin_url)).search(field).first
        if time_field
          self.published_at = Time.parse(parse_datetime(time_field.content))
        end
      end
    end
    save
  end

  handle_asynchronously :process
  
  def word_processing(content)
    content.gsub!("\n", "<br />")
    content.gsub!("\r", "")
    content.gsub!("\t", " ")
    content.gsub!("", "\"")
    content.gsub!("", "\"")
    content.gsub!("", "'")
    content.lstrip!
    content
  end

  def parse_datetime(datetime)
    regex = "(.*)/(.*)/(.*)( .* )([0-9]*):([0-9]*)|(:([0-9]*))"
    if datetime.match(regex)
      "#{parse_date(datetime)} #{parse_time(datetime)}"
    end
  end

  protected
  
  def create_slug
    self.slug = title.parameterize
  end
  
  def remove_www_from_origin_url
    self.origin_url = origin_url.remove_www
  end
  
  def parse_date(date)
    regex = "([0-9]*)[/|-]([0-9]*)[/|-]([0-9]*)"
    "#{date.match(regex)[2]}/#{date.match(regex)[1]}/#{date.match(regex)[3]}"
  end
  
  def parse_time(time)
    regex = "([0-9]*)[h]?:([0-9]*)"
    "#{time.match(regex)[1]}:#{time.match(regex)[2]}"
  end
end