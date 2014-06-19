# -*- encoding : utf-8 -*-
class BankPayment < ActiveRecord::Base

  scope :unpaired, -> { where(accounting_status: :pending) }

  validate unique: :transaction_id

  has_one :payment
  has_one :membership_fee
  has_one :supporter_fee

  include AASM

  aasm :column => 'accounting_status' do
    state :pending, :initial => true
    state :completed

    event :process_payment do
      transitions :from => :pending, :to => :completed
    end
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

  def pair
  	# sestaví seznam nespárovaných plateb se stejným variabilním symbolem
  	bank_payments =  BankPayment.unpaired.where(vs: vs)
  	# odešle seznam do registru Svobodných
  	options = { body: {payments: bank_payments.to_json(only: [:payed_on, :amount])} }
    response = HTTParty.post("#{configatron.registry.uri}/people/#{vs}/payments.json", options)
    # získané údaje zapíšeme k platbám
    bank_payments.each{ |bank_payment|
      payment = response["payment"].except('membership_type','accounting_note'
      		).merge({paid_on: bank_payment.paid_on, amount: bank_payment.amount})
      if response["payment"]["membership_type"]=="member"
      	bank_payment.build_membership_fee(payment)
      else
      	bank_payment.build_supporter_fee(payment)
      end
      bank_payment.accounting_note=response['payment']['accounting_note']
      bank_payment.process_payment!
    } if response.success?
  end

end

