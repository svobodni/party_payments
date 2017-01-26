class BankImportWorker
  include Sidekiq::Worker

  def perform
#    BankPayment.import
#    BankPayment.where("paid_on>'2015-12-31' and organization_id is not null").each{|bp| bp.pair}
#    GopayPayment.import
    BankPayment.where(our_account_number:2100382818).where("id>12280").each{|bp| bp.pair}
    BankAccount.all.each{|bank_account| bank_account.import}
  end
end
