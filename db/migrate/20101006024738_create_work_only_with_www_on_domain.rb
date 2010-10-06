class CreateWorkOnlyWithWwwOnDomain < ActiveRecord::Migration
  def self.up
    add_column :domains, :work_only_with_www, :boolean, :default => true
  end

  def self.down
    remove_column :domains, :work_only_with_www
  end
end