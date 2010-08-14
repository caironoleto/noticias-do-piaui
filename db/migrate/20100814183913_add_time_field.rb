class AddTimeField < ActiveRecord::Migration
  def self.up
    add_column :domains, :nokogiri_time_fields, :string
  end

  def self.down
    remove_column :domains, :nokogiri_time_fields
  end
end