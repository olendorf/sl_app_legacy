class AddImageKeyToRezzableVendor < ActiveRecord::Migration[5.2]
  def change
    add_column :rezzable_vendors, :image_key, :string, 
               default: '00000000-0000-0000-0000-000000000000'
  end
end
