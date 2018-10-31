class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name
      t.text :description
      t.datetime :created_at
      t.datetime :update_at
      t.boolean :enabled

      t.timestamps
    end
  end
end
