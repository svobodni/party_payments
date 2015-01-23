class AddAccountNumberAndTokenToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :account_number, :string
    add_column :organizations, :token, :string
  end
end
