class AddEnvironmentIdToInstances < ActiveRecord::Migration
  def self.up
    add_column :instances, :environment_id, :integer
  end

  def self.down
    remove_column :instances, :environment_id
  end
end
