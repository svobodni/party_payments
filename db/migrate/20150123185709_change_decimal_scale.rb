class ChangeDecimalScale < ActiveRecord::Migration

  def up
    change_column :accountings, :amount, :decimal, precision: 10, scale: 2
    change_column :donations, :amount, :decimal, precision: 10, scale: 2
  end

  def down
    change_column :accountings, :amount, :decimal, precision: 10, scale: 0
    change_column :donations, :amount, :decimal, precision: 10, scale: 0
  end

end
