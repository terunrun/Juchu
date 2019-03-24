class AddReleaseAccountLockToCustomers < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :release_account_lock_digest, :string
  end
end
