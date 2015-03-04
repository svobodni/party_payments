class AddExportedToFioToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :exported_to_fio, :boolean
  end
end
