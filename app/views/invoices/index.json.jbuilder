json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :description, :amount, :vs, :ss, :ks, :account_number, :bank_code
  json.url invoice_url(invoice, format: :json)
end
