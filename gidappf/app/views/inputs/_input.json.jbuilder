json.extract! input, :id, :title, :summary, :grouping, :enable, :author, :created_at, :updated_at
json.url input_url(input, format: :json)
