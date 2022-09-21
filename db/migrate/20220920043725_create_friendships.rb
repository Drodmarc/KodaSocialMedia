class CreateFriendships < ActiveRecord::Migration[6.1]
  def change
    create_table :friendships do |t|
      t.string :state
      t.belongs_to :user
      t.belongs_to :friend
      t.timestamps
    end
  end
end