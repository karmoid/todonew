class CreateEventIntervLinks < ActiveRecord::Migration
  def self.up
    create_table :event_interv_links do |t|
      t.integer :intervenant_id
      t.integer :event_id

      t.timestamps
    end
  end

  def self.down
    drop_table :event_interv_links
  end
end
