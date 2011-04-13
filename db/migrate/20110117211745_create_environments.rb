class CreateEnvironments < ActiveRecord::Migration
  def self.up
    create_table :environments do |t|
      t.string :description
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :environments
  end
end
