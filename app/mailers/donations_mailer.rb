class DonationsMailer < ActionMailer::Base
  default from: "kancelar@svobodni.cz"

  def agreement(donation)
    @donation = donation
    attachments['svobodni_smlouva.pdf'] = DonationAgreementPdf.new(donation).render
    mail(to: donation.email, subject: 'Svobodní - darovací smlouva')
  end

  def non_monetary_agreement(donation)
    @donation = donation
    attachments['svobodni_smlouva.pdf'] = DonationAgreementPdf.new(donation).render
    mail(to: donation.email, subject: 'Svobodní - darovací smlouva')
  end

end
