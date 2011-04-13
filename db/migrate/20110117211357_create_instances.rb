class CreateInstances < ActiveRecord::Migration
  def self.up
    create_table :instances do |t|
      t.string :sid
      t.string :db
      t.integer :server_id
      t.integer :branch_id
      t.string :description
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :instances
  end
end
