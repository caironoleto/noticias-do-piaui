class AddDomainIdInArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :domain_id, :integer
  end

  def self.down
    remove_column :articles, :domain_id
  end
end