class AddUserAdminToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_admin, :boolean
  end
end
