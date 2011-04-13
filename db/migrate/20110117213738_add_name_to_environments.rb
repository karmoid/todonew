class AddNameToEnvironments < ActiveRecord::Migration
  def self.up
    add_column :environments, :name, :string
  end

  def self.down
    remove_column :environments, :name
  end
end
