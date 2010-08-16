class Domain < ActiveRecord::Base
  has_many :articles
  def process
    Feedzirra::Feed.fetch_and_parse(feed_url).entries.each do |entry|
      unless articles.find_by_origin_url(entry.url).present?
        article = articles.create(:title => entry.title, :origin_url => entry.url)
        Delayed::Job.enqueue article
      end
    end
  end
end
