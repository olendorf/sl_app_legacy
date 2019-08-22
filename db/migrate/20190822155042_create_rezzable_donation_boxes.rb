class CreateRezzableDonationBoxes < ActiveRecord::Migration[5.2]
  def change
    create_table :rezzable_donation_boxes do |t|
      t.integer :reset_period, default: 0
      t.integer :last_donor, default: 0
      t.integer :last_donation, default: 0
      t.integer :biggest_donor, default: 0

      t.timestamps
    end
  end
end
