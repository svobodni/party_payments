class BankImportWorker
  include Sidekiq::Worker

  def perform
    BankPayment.import
    BankPayment.where("paid_on>'2014-12-31'").each{|bp| bp.pair}
    GopayPayment.import
  end
end
