class AddCustomerIdToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :customer_id, :integer
    add_column :products, :description, :string
  end
end
