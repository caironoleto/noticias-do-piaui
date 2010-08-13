class AddParagraphTagOnDomain < ActiveRecord::Migration
  def self.up
    add_column :domains, :paragraph_tag, :string
  end

  def self.down
    remove_column :domains, :paragraph_tag
  end
end