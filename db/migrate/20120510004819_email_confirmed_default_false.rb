class EmailConfirmedDefaultFalse < ActiveRecord::Migration
  def up
    change_column :users, :email_confirmed, :boolean, :default => false
  end

  def down
    # You can't currently remove default values in Rails
    raise ActiveRecord::IrreversibleMigration, "Can't remove the default"
  end
end
