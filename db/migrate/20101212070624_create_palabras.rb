class CreatePalabras < ActiveRecord::Migration
  def self.up
    create_table :palabras do |t|
      t.integer :verb_id
      t.integer :forma_id
      t.integer :tiempo_id
      t.string :name
    end
  end

  def self.down
    drop_table :palabras
  end
end
