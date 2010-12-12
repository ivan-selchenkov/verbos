class CreateTiempos < ActiveRecord::Migration
  def self.up
    create_table :tiempos do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :tiempos
  end
end
