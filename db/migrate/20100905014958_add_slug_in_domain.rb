class AddSlugInDomain < ActiveRecord::Migration
  def self.up
    add_column :domains, :slug, :string
    add_index :domains, :slug
  end
  
  def self.down
    remove_index :domains, :slug
    remove_column :domains, :slug
  end
end