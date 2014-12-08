json.array!(@budget_categories) do |budget_category|
  json.extract! budget_category, :id, :organization_id, :year, :name
  json.url budget_category_url(budget_category, format: :json)
end
