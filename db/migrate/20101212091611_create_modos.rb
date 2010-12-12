class CreateModos < ActiveRecord::Migration
  def self.up
    create_table :modos do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :modos
  end
end
