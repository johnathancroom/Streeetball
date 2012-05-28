class AddEmailConfirmationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_confirmation_token, :string
  end
end
