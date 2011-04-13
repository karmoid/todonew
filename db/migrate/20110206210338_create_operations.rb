class CreateOperations < ActiveRecord::Migration
  def self.up
    create_table :operations do |t|
      t.string :name
      t.string :description
      t.integer :opegroup_id
      t.string :cal_color
      t.string :short_name

      t.timestamps
    end
  end

  def self.down
    drop_table :operations
  end
end
