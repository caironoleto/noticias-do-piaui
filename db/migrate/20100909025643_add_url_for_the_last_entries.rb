class AddUrlForTheLastEntries < ActiveRecord::Migration
  def self.up
    add_column :domains, :last_news_url, :string
    add_column :domains, :last_news_search_field, :string
  end

  def self.down
    remove_column :domains, :last_news_search_field
    remove_column :domains, :last_news_url
  end
end