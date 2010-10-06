class Domain < ActiveRecord::Base
  has_many :articles
  before_save :create_slug

  def create_slug
    self.slug = title.parameterize.to_s
  end

  def process
    process_from_the_feed
    process_from_the_url
  end

  protected
  def process_from_the_feed
    if feed_url.present?
      feed = Feedzirra::Feed.fetch_and_parse(feed_url)
      if feed.present? && feed.respond_to?(:entries)
        feed.entries.each do |entry|
          unless articles.find_by_slug(entry.title.parameterize.to_s).present?
            article = articles.create(:title => entry.title, :origin_url => entry.url)
            article.process
          end
        end
      end
    end
  end

  def process_from_the_url
    require 'open-uri'
    if last_news_url.present?
      entries = Nokogiri::HTML(open(last_news_url)).search(last_news_search_field)
      if entries.present?
        entries.each do |entry|
          unless articles.find_by_slug(entry.attributes["title"].content.parameterize.to_s).present?
            article = articles.create(:title => entry.attributes["title"].content, :origin_url => entry.attributes["href"].content)
            article.process
          end
        end
      end
    end
  end
end
