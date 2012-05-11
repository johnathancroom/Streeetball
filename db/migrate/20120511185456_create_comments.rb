class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.text :blurb
      t.integer :post_id

      t.timestamps
    end
  end
end
