# Preview all emails at http://localhost:3000/rails/mailers/donations
class DonationsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/donations_mailer/agreement
  def agreement
    #DonationsMailer.agreement(Donation.last)
    DonationsMailer.agreement(DonationFormSubmission.last.to_donation)
  end

end
