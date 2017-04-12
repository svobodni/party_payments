class DonationFormSubmission < ActiveRecord::Base

  store :params, coder: JSON

  after_create :send_email_with_agreement

  def to_donation
    Donation.new(
      organization_id: 100,
      vs: params["orderNumber"],
      amount: params["totalPrice"].to_f/100,
      donor_type: (params["companyName"].blank? ? 'natural' : 'juristic'),
      name: (params["companyName"].blank? ? [params["firstName"],params["lastName"]].join(" ") : params["companyName"]),
      date_of_birth: params["birthdate"],
      ic: params["companyId"],
      street: params["street"],
      city: params["city"],
      zip: params["postalCode"],
      email: params["email"]
    )
  end

  private
  def send_email_with_agreement
    DonationsMailer.agreement(self.to_donation).deliver
  end
end
