class AddIndexInArticles < ActiveRecord::Migration
  def self.up
    add_index :articles, :slug
  end

  def self.down
    remove_index :articles, :slug
  end
end