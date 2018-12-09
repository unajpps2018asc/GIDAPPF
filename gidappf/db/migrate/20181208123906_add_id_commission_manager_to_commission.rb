class AddIdCommissionManagerToCommission < ActiveRecord::Migration[5.2]
  def change
    add_reference :commissions, :user, foreign_key: true
  end
end
