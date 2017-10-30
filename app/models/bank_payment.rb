# -*- encoding : utf-8 -*-
class BankPayment < ActiveRecord::Base

  scope :unpaired, -> { where(accounting_status: :pending) }

  validate unique: :transaction_id

  has_many :payments, as: :payment
  belongs_to :organization
  # belongs_to :bank_account

  #has_one :payment
  #has_one :membership_fee
  #has_one :supporter_fee

  has_many :accountings, as: :payment

  has_one :returning_payment, class_name: 'BankPayment', foreign_key: :returned_payment_id
  belongs_to :returned_payment, class_name: 'BankPayment'

  include AASM

  aasm :column => 'accounting_status' do
    state :pending, :initial => true
    state :completed

    event :process_payment do
      transitions :from => :pending, :to => :completed
    end
  end

  def self.import
    Organization.all.each {|organization|
      FioAPI.token = organization.token
      list = FioAPI::List.new
      list.from_last_fetch

      response = list.response
      response.transactions.each do |row|
        puts row.inspect
        create!(
          :organization_id => organization.id,
          :amount => row.amount,
          :paid_on => Date.parse(row.date),
          :currency => row.currency,
          :transaction_id => row.transaction_id,
          :account_number => row.account,
          :bank_code => row.bank_code,
          :vs => row.vs || '',
          :ks => row.ks || '',
          :ss => row.ss || '',
          :info => row.message_for_recipient || '',
          :account_name => row.account_name || '',
          :our_account_number => response.account.account_id,
          :our_bank_code => response.account.bank_id
        ) unless find_by_transaction_id_and_organization_id(row.transaction_id,organization.id)
      end
    }
  end

  def bank_account
    # FIXME: reference u importu
    @bank_account ||= BankAccount.find_by_account_number(our_account_number)
  end

  def donation_expected?
    bank_account.account_type==1 && remaining_amount>0
  end

  def positive_amount
    amount < 0 ? amount*-1 : amount
  end

  def remaining_amount
    if amount < 0
      amount + payments.inject(0){|sum,p| sum + p.amount }
    else
      amount - payments.inject(0){|sum,p| sum + p.amount }
    end
  end

  def registry_payment?
    (organization.nil? || organization.id==100) && vs.length==5 && (vs[0]=="1" || vs[0]=="5")
  end

  def pair
    if !(returning_payment || returned_payment)
      if remaining_amount < 0
        if invoice = Invoice.where(amount: positive_amount).detect{|i| i.vs==vs && i.account_number==account_number}
          payments.create(payable: invoice, amount: positive_amount)
        end
      elsif remaining_amount > 0 &&
          vs.length==5 &&
          ((our_account_number=="7505075050" && vs[0]=="5") ||
          (our_account_number==MembershipFee.account && vs[0]=="1"))
        response = HTTParty.post("#{configatron.registry.uri}/people/#{vs}/payments.json", basic_auth: configatron.registry.auth)
        if response.success?
          if response["payment"]["membership_type"]=="member" && vs[0]=="1" && our_account_number==MembershipFee.account
            membership_fee = MembershipFee.create(
              region_id: response["payment"]["region_id"],
              amount: amount,
              person_id: response["payment"]["id"],
              name: response["payment"]["name"],
              received_on: paid_on
            )
            payments.create(payable: membership_fee, amount: positive_amount)
            if remaining_amount > 299
              response = HTTParty.post("#{configatron.registry.uri}/people/#{vs}/paid.json", basic_auth: configatron.registry.auth)
            end
          elsif response["payment"]["membership_type"]=="supporter" && vs[0]=="5" && our_account_number=="7505075050"
            donation = Donation.create(
              organization_id: 100,
              amount: amount,
              donor_type: 'natural',
              person_id: response["payment"]["id"],
              name: response["payment"]["name"],
              date_of_birth: response["payment"]["date_of_birth"],
              street: response["payment"]["street"],
              city: response["payment"]["city"],
              zip: response["payment"]["zip"],
              email: response["payment"]["email"],
              received_on: paid_on
            )
            payments.create(payable: donation, amount: positive_amount)
            response = HTTParty.post("#{configatron.registry.uri}/people/#{vs}/paid.json", basic_auth: configatron.registry.auth)
          end
        end
      elsif remaining_amount > 0 &&
          (our_account_number=="7505075050") &&
          vs.length==5 && vs[0]=="8"
        data = DonationFormSubmission.all.select{|d| d.params["orderNumber"]==vs}.last
        if data && data.params["totalPrice"].to_f/100==amount
          donation = data.to_donation
          donation.received_on = paid_on
          payments.create(payable: donation, amount: positive_amount)
        end
      elsif remaining_amount > 0 &&
          (our_account_number=="7505075050") &&
          vs.length==10 && vs[0..1]=="99"
        donation = Donation.find_by(vs: vs)
        if donation && donation.amount==amount
          donation.received_on = paid_on
          donation.set_accounting
          donation.save
          payments.create(payable: donation, amount: positive_amount)
        end
      end
    end
  end

end
