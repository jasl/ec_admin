class Instance < ActiveRecord::Base
  attr_accessible :db_host, :db_name, :db_passwd, :db_port, :db_user, :name, :note, :url
end
