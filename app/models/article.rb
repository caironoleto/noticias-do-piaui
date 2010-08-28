class Article < ActiveRecord::Base
  belongs_to :domain
  before_save :create_slug
  
  def create_slug
    self.slug = title.parameterize
  end
  
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
          self.published_at = Time.parse(parse_time(time_field.content))
        end
      end
    end
    save
  end

  def parse_time(time)
    regex = "(.*)/(.*)/(.*)( .* )([0-9]*):([0-9]*)|(:([0-9]*))"
    if time.match(regex)
      "#{time.match(regex)[2]}/#{time.match(regex)[1]}/#{time.match(regex)[3]} #{time.match(regex)[5]}:#{time.match(regex)[6]}"
    end
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
  
end