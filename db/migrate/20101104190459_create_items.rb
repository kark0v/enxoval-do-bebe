class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.string :price
      t.integer :user_id
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
