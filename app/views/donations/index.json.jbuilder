json.array!(@donations) do |donation|
  json.extract! donation, :id, :organization_id, :amount, :donor_type, :person_id, :name, :ic, :date_of_birth, :street, :city, :zip, :email
  json.url donation_url(donation, format: :json)
end
