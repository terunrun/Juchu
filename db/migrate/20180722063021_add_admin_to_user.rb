class AddAdminToUser < ActiveRecord::Migration[5.2]
  def change
    # ユーザーに管理者カラムを追加、デフォルトでは非管理者とする
    add_column :users, :admin, :boolean, default: false
  end
end
