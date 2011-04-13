class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :description
      t.integer :operation_id
      t.text :note
      t.datetime :planned
      t.datetime :done
      t.datetime :cancelled
      t.boolean :all_day
      t.text :status
      t.references :eventable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
