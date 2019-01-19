class CreateTimeSheetHours < ActiveRecord::Migration[5.2]
  def change
    create_table :time_sheet_hours do |t|
      t.references :time_sheet, foreign_key: true
      t.string :hs_from
      t.string :hs_to

      t.timestamps
    end
  end
end
