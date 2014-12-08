json.array!(@accountings) do |accounting|
  json.extract! accounting, :id, :accountable_type, :accountable_id, :budget_category_id, :payment_type, :payment_id, :amount
  json.url accounting_url(accounting, format: :json)
end
