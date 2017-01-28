class BankImportWorker
  include Sidekiq::Worker

  def perform
#    BankPayment.import
#    BankPayment.where("paid_on>'2015-12-31' and organization_id is not null").each{|bp| bp.pair}
#    GopayPayment.import
    BankAccount.all.each{|bank_account| bank_account.import}
  end
end
