json.extract! time_sheet_hour, :id, :time_sheet_id, :from_hour, :from_min, :to_hour, :to_min, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :created_at, :updated_at
json.url time_sheet_hour_url(time_sheet_hour, format: :json)
