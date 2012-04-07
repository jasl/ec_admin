class CreateBackupRecords < ActiveRecord::Migration
  def change
    create_table :backup_records do |t|
      t.string :name
      t.string :note
      t.string :file

      t.timestamps
    end
  end
end
