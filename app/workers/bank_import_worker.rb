class BankImportWorker
  include Sidekiq::Worker

  def perform
#    BankPayment.import
#    GopayPayment.import
    last_bank_payment = BankPayment.last
    BankAccount.all.each{|bank_account| bank_account.import}
    BankPayment.where(our_account_number:2100382818).where("id>#{last_bank_payment.id}").each{|bp| bp.pair}
    BankPayment.where("paid_on>'2016-12-31' and amount<0").includes(:payments).select{|bp| bp.returned_payment.blank?}.select{|bp| bp.payments.blank?}.each{|bp| bp.pair}
  end
end
