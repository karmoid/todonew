class AddSpriteToOperation < ActiveRecord::Migration
  def self.up
    add_column :operations, :spriteplan, :string
    add_column :operations, :spritedone, :string
    add_column :operations, :spritecancel, :string
  end

  def self.down
    remove_column :operations, :spriteplan
    remove_column :operations, :spritedone
    remove_column :operations, :spritecancel
  end
end
