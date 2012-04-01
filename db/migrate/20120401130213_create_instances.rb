class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.string :name
      t.string :url
      t.string :db_host
      t.integer :db_port
      t.string :db_name
      t.string :db_user
      t.string :db_passwd
      t.text :note
      t.string :state, :default => 'normal'

      t.timestamps
    end
  end
end
