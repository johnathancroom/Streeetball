class RemoveEmailConfirmationColumn < ActiveRecord::Migration
  def change
    remove_column :users, :email_confirmation_code
  end
end
