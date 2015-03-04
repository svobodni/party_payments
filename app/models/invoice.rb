class Invoice < ActiveRecord::Base

  belongs_to :organization
  has_many :accountings, as: :accountable
  has_many :payments, as: :payable

  has_attached_file :document, path: ":rails_root/data/invoices/:id.pdf", url: "/invoices/:id.pdf"
  validates_attachment :document, content_type: { content_type: "application/pdf" }

  def accounting_remainder
  	amount.to_f-accountings.sum(:amount)
  end

  def payment_remainder
  	amount.to_f-payments.sum(:amount)
  end

  def import_transaction_to_fio
    FioAPI.token = organization.token

    domestic_transaction = DomesticTransaction.new(
    :account_from => organization.account_number,
    :currency => 'CZK',
    :amount => amount,
    :account_to => account_number,
    :bank_code => bank_code,
    :vs => vs || '',
    :date => Date.today,
    :message_for_recipient => description
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
