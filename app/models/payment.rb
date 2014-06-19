class Payment < ActiveRecord::Base
  belongs_to :bank_payment
end
