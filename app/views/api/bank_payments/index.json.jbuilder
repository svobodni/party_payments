json.balance BankAccount.balance
json.payments(@bank_payments) do |bank_payment|
  json.extract! bank_payment, :paid_on, :amount, :info, :account_name
# #  json.url payment_url(payment, format: :json)
end
