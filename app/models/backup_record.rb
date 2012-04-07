class BackupRecord < ActiveRecord::Base
  attr_accessible :file, :name, :note, :created_at
end
