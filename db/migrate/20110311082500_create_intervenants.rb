class CreateIntervenants < ActiveRecord::Migration
  def self.up
    create_table :intervenants do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :phone1
      t.string :phone2
      t.integer :entity_id
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :intervenants
  end
end
