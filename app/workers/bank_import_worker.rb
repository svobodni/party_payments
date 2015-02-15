class BankImportWorker
  include Sidekiq::Worker

  def perform
    BankPayment.import
    BankPayment.all.each{|bp| bp.pair}
  end
end
