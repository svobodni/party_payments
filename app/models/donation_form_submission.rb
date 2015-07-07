class DonationFormSubmission < ActiveRecord::Base

  store :params, coder: JSON

end
