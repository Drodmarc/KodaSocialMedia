class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.string :image
      t.integer :privacy
      t.timestamps
    end
  end
end