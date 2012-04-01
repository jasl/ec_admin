# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Instance.destroy_all

@host = '192.168.1.5'
3.times do |i|
  @no = "%03d" % (i+1)
  Instance.create :name => @no,
                  :url => "http://#{@host}/#{@no}",
                  :db_host => @host,
                  :db_port => 3306,
                  :db_name => "ecstore#{@no}",
                  :db_user => 'root',
                  :db_passwd => ''
end
