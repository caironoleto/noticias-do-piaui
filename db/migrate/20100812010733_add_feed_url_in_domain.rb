class AddFeedUrlInDomain < ActiveRecord::Migration
  def self.up
    add_column :domains, :feed_url, :string
  end

  def self.down
    remove_column :domains, :feed_url
  end
end