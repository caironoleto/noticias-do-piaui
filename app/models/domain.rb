class Domain < ActiveRecord::Base
  has_many :articles
  before_save :create_slug

  def create_slug
    self.slug = title.parameterize.to_s
  end
  
  def process
    Feedzirra::Feed.fetch_and_parse(feed_url).entries.each do |entry|
      unless articles.find_by_origin_url(entry.url).present?
        article = articles.create(:title => entry.title, :origin_url => entry.url)
        article.process
      end
    end
  end
end
