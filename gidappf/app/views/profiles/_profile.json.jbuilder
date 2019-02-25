json.extract! profile, :id, :name, :description, :valid_to, :valid_from, :created_at, :updated_at
json.url profile_url(profile, format: :json)
