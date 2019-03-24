class AddColumnToCustomers < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :login_failed_number, :integer, null: false, default: 0
    add_column :customers, :unavailable_flg, :boolean, null: false, default: false
  end
end
