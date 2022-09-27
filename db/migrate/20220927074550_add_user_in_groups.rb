class AddUserInGroups < ActiveRecord::Migration[6.1]
  def change
    add_reference :groups, :user, index: true
  end
end