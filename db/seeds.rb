# -*- encoding : utf-8 -*-
p 'Clearing instance and user records'
Instance.destroy_all
User.destroy_all

p 'Generating instance records'
@host = '192.168.1.5'
5.times do |i|
  @no = "%03d" % (i+1)
  Instance.create :name => @no,
                  :url => "http://#{@host}/#{@no}",
                  :db_host => @host,
                  :db_port => 3306,
                  :db_name => "ecstore#{@no}",
                  :db_user => 'root',
                  :db_passwd => ''
end

p 'Generating user records'
User.create({:name => '姜军',
            :email => 'jasl123@126.com',
            :password => 'aaaaaa',
            :state => true},
            :as => :admin)

p 'Seeds generated done'
