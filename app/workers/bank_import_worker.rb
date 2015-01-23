class BankImportWorker
  include Sidekiq::Worker

  def perform
    BankPayment.import
  end
end
