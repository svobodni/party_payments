class BankAccount < ActiveRecord::Base

  validates :name, presence: true
  validates :description, presence: true
  validates :account_type, presence: true
  validates :account_number, presence: true, format: { with: /\A[0-9\-]{2,20}\z/ }
  validates :bank_code, presence: true, format: { with: /\A[0-9]{4}\z/ }

  has_many :payments, class_name: "BankPayment", foreign_key: :our_account_number, primary_key: :account_number

  def full_account_number
    [account_number, bank_code].join('/')
  end

  def our_full_account_number
    [our_account_number, our_bank_code].join('/')
  end

  def self.account_types
    # http://www.zakonyprolidi.cz/cs/1991-424#p17a-2
    {
      "příspěvky ze státního rozpočtu, příjmy z darů a jiných bezúplatných plnění" => 1,
      "plnění vyplývající z pracovněprávního vztahu ke straně a hnutí a politickému institutu" => 2,
      "financování volebních kampaní za podmínek stanovených volebními zákony" => 3,
      "ostatní příjmy a výdaje" => 4
    }
  end

  def import
    FioAPI.token = token
    list = FioAPI::List.new
    list.from_last_fetch
    response = list.response
    account = response.account
    update_attribute :balance, account.closing_balance
    response.transactions.each { |transaction|
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

  def self.balance
    all.sum(:balance)
  end

end
