class CreateCrowdfundings < ActiveRecord::Migration
  def change
    create_table :crowdfundings do |t|
      t.string :vs_prefix
      t.string :title
      t.text :perex
      t.integer :price
      t.string :unit
      t.string :image_url
      t.text :description

      t.timestamps
    end
  end
end
