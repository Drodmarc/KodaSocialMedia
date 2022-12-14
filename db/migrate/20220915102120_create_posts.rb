class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :content
      t.string :image
      t.integer :genre
      t.belongs_to :user
      t.timestamps
    end
  end
end