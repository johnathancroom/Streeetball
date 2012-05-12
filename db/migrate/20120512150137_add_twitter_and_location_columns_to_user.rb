class AddTwitterAndLocationColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :twitter_username, :string
    add_column :users, :location, :string
  end
end
