class Domain < ActiveRecord::Base
  has_many :articles
  def process
    Feedzirra::Feed.fetch_and_parse(feed_url).entries.each do |entry|
      articles.create(:title => entry.title, :origin_url => entry.url) unless articles.find_by_origin_url(entry.url).present?
    end
  end
end
