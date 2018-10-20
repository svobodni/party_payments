class Invoice < ActiveRecord::Base

  has_many :events, as: :eventable

  belongs_to :organization
  has_many :accountings, as: :accountable
  has_many :payments, as: :payable

  before_validation :sanitize_arguments

  has_attached_file :document, path: ":rails_root/data/invoices/:id.pdf", url: "/faktury/:id.pdf"
  validates_attachment :document, content_type: { content_type: ["application/pdf"] }

  attr_accessor :account

  def sanitize_arguments
    self.vs=self.vs.strip if self.vs
    self.account_number=self.account_number.strip.sub!(/^[0]*/,'') if self.account_number
  end

  def accounting_remainder
  	(amount||0)-accountings.sum(:amount)
  end

  def payment_remainder
  	(amount||0)-payments.sum(:amount)
  end

  def approved?
    approved_on
  end

  def is_exportable?
    !(exported_to_fio? || payment_remainder==0 || account_number.blank? || bank_code.blank?)
  end

  def import_transaction_to_fio(our_account_number,desc=description)
    account=BankAccount.find_by_account_number(our_account_number)
    FioAPI.token = account.token

    domestic_transaction = DomesticTransaction.new(
    :account_from => our_account_number,
    :currency => 'CZK',
    :amount => amount,
    :account_to => account_number,
    :bank_code => bank_code,
    :vs => vs || '',
    :ss => ss || '',
    :ks => ks || '',
    :date => Date.today,
    :message_for_recipient => desc,
    :comment => desc
    )

    result = domestic_transaction.import

    if result.parsed_response
      # 0 = ok - prikaz byl prijat
      success = result.parsed_response['responseImport']['result']['errorCode'] == '0'

      notice = result.parsed_response['responseImport']['result']['status'] +
      " (errorCode: #{result.parsed_response['responseImport']['result']['errorCode']})"

      message = result.parsed_response['responseImport']['result']['message']

      if message
        notice << " - #{message}"
      elsif !success
        notice << " - #{result.inspect}"
      end
      success = false
      notice = "HTTP #{result.code}"
    end

    update_attribute(:exported_to_fio, true) if success

    return notice
  end

end
