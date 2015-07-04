# -*- encoding : utf-8 -*-
class GopayPayment < ActiveRecord::Base

  validate unique: :transaction_id

  has_many :payments, as: :payment

  def remaining_amount
    amount - payments.inject(0){|sum,p| sum + p.amount }
  end

  def self.import
    Gopay.statement(from: Date.today-1.month, to: Date.today).collect{|row|
      create(
        transaction_id:row[0],
        paid_on:row[1],
        info:row[2],
        account_name:row[3],
        vs:row[4],
        amount:row[5],
        currency:row[8],
        reference_id:row[9],
        paid_at:row[1]
      ) unless find_by_transaction_id(row[0])
    }
  end

end
