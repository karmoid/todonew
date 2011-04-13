class CreateServers < ActiveRecord::Migration
  def self.up
    create_table :servers do |t|
      t.string :name
      t.string :description
      t.string :alias
      t.integer :branch_id
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :servers
  end
end
