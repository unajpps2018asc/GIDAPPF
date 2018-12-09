class AddCommissionIdToUsercommissionrole < ActiveRecord::Migration[5.2]
  def change
    add_reference :usercommissionroles, :commission, foreign_key: true
  end
end
