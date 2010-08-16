class Article < ActiveRecord::Base
  belongs_to :domain
  before_save :create_slug
  
  def create_slug
    self.slug = title.parameterize
  end
  
  def perform
    self.text = ""
    require 'open-uri'
    article = Nokogiri::HTML(open(origin_url)).search(domain.nokogiri_search_field).first
    if article
      article.children.each do |element|
        if element.content.present?
          content = element.content
          content.gsub!("\n", "<br />")
          content.gsub!("\r", "")
          content.gsub!("\t", " ")
          content.lstrip!
        end

        if element.name == domain.paragraph_tag && content.present? && content.size > 8
          self.text << "<p>#{content}</p>"
        end
      end
      self.published_at = Time.now
    end
    save
  end
end
