json.extract! time_sheet, :id, :commission_id, :start_date, :end_date, :enabled, :created_at, :updated_at
json.url time_sheet_url(time_sheet, format: :json)
