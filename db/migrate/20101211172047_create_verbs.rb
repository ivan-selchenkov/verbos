class CreateVerbs < ActiveRecord::Migration
  def self.up
    create_table :verbs do |t|
      t.string :verbo
    end
  end

  def self.down
    drop_table :verbs
  end
end
