class DropPaymentsTable < ActiveRecord::Migration
  def change
  	drop_table :accountings
  end
end
