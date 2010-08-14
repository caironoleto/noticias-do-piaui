class Article < ActiveRecord::Base
  belongs_to :domain
  after_save :add_process_in_delayed_job
  before_save :create_slug
  
  def add_process_in_delayed_job
    process
  end
  
  def create_slug
    self.slug = title.parameterize
  end

  handle_asynchronously :add_process_in_delayed_job
  
  def process
    self.text = ""
    Nokogiri::HTML(origin_url).search(domain.nokogiri_search_field).first.children.each do |element|
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
    save
  end
end