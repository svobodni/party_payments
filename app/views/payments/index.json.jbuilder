json.array!(@payments) do |payment|
  json.extract! payment, :id, :payment_type, :payment_id, :amount, :payable_type, :payable_id
  json.url payment_url(payment, format: :json)
end
