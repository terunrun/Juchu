class AddRememberDigestToCustomers < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :remember_digest, :string
  end
end
