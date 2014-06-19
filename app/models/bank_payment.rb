# -*- encoding : utf-8 -*-
class BankPayment < ActiveRecord::Base

  validate unique: :transaction_id

  include AASM

  aasm :column => 'accounting_status' do
    state :pending, :initial => true
    state :completed
  end

  def self.import
    list = FioAPI::List.new
    list.set_last_fetch_date((Date.today-10.days).to_s)
    list.from_last_fetch

    response = list.response
    response.transactions.each do |row|
      create!(
        :amount => row.amount,
        :payed_on => Date.parse(row.date),
        :currency => row.currency,
        :transaction_id => row.transaction_id,
        :account_number => row.account,
        :bank_code => row.bank_code,
        :vs => row.vs || '',
        :ks => row.ks || '',
        :ss => row.ss || '',
        :info => row.message_for_recipient || '',
        :account_name => row.user_identification || '',
      ) unless find_by_transaction_id(row.transaction_id)
    end
  end

end

