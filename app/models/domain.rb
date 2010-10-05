class Domain < ActiveRecord::Base
  has_many :articles
  before_save :create_slug

  def create_slug
    self.slug = title.parameterize.to_s
  end
  
  def process
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    if feed.present? && feed.respond_to?(:entries)
      feed.entries.each do |entry|
        unless articles.find_by_origin_url(entry.url.remove_www).present?
          article = articles.create(:title => entry.title, :origin_url => entry.url)
          article.process
        end
      end
    else
      require 'open-uri'
      entries = Nokogiri::HTML(open(last_news_url)).search(last_news_search_field)
      if entries.present?
        entries.each do |entry|
          unless articles.find_by_origin_url(entry.attributes["href"].content).present?
            article = articles.create(:title => entry.attributes["title"].content, :origin_url => entry.attributes["href"].content)
            article.process
          end
        end
      end
    end
  end
end
