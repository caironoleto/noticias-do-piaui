class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.text :text
      t.string :origin_url
      t.datetime :published_at

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
