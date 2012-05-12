class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :bio, :text
    add_column :users, :image_url, :string
  end
end
