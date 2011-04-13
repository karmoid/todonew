class ChangeTypeEntiteToBranch < ActiveRecord::Migration
  def self.up
    add_column :branches, :entity_id, :integer
    remove_column :branches, :entite
  end

  def self.down
    add_column :branches, :entite, :string
    remove_column :branches, :entity_id, :integer
  end
end
