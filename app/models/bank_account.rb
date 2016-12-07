class BankAccount < ActiveRecord::Base

  validates :name, presence: true
  validates :description, presence: true
  validates :account_type, presence: true
  validates :account_number, presence: true, format: { with: /\A[0-9\-]{2,20}\z/ }
  validates :bank_code, presence: true, format: { with: /\A[0-9]{4}\z/ }

  has_many :payments, class: BankPayment, foreign_key: :our_account_number, primary_key: :account_number

  def full_account_number
    [account_number, bank_code].join('/')
  end

  def our_full_account_number
    [our_account_number, our_bank_code].join('/')
  end

  def self.account_types
    {"Dary"=>1, "Příspěvky členů"=>2}
  end

  def import
    FioAPI.token = token
    list = FioAPI::List.new
    list.by_date_range(Date.new(2016,11,03), Date.today)
    # list.set_last_fetch_date(Date.new(2016,11,05))
    # list.from_last_fetch
    account = list.response.account
    update_attribute :balance, account.closing_balance
    list.response.transactions.each { |transaction|
      BankPayment.create!(
        amount: transaction.amount,
        paid_on: Date.parse(transaction.date),
        currency: transaction.currency,
        transaction_id: transaction.transaction_id,  # 13850125596
        account_number: transaction.account,
        account_name: transaction.account_name,
        bank_code: transaction.bank_code,
        vs: transaction.vs || '',
        ks: transaction.ks || '',
        ss: transaction.ss || '',
        info: transaction.message_for_recipient || '',
        our_account_number: account.account_id,
        our_bank_code: account.bank_id,
      ) unless BankPayment.find_by_transaction_id_and_our_account_number(transaction.transaction_id,account.account_id)
    }

  end
end
