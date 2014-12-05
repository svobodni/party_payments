json.array!(@bank_payments) do |bank_payment|
  json.extract! bank_payment, :id, :name
  json.url restaurant_url(bank_payment, format: :json)
end