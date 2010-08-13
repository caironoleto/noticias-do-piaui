class AddNokogiriField < ActiveRecord::Migration
  def self.up
    add_column :domains, :nokogiri_search_field, :string
  end

  def self.down
    remove_column :domains, :nokogiri_search_field
  end
end