class AddStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :state, :boolean, :default => false
  end
end
