class CreateBranches < ActiveRecord::Migration
  def self.up
    create_table :branches do |t|
      t.string :name
      t.string :description
      t.string :entite
      t.text :note
      t.float :long
      t.float :lat
      t.integer :refreshed

      t.timestamps
    end
  end

  def self.down
    drop_table :branches
  end
end
