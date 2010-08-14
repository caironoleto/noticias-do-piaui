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
          self.published_at = Time.parse(time_field.content)
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
  
end