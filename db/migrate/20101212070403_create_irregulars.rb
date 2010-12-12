class CreateIrregulars < ActiveRecord::Migration
  def self.up
    create_table :irregulars do |t|
      t.integer :verb_id
      t.integer :tiempo_id
      t.integer :irregular
    end
  end

  def self.down
    drop_table :irregulars
  end
end
