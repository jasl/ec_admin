class Instance < ActiveRecord::Base
  attr_accessible :db_host, :db_name, :db_passwd, :db_port, :db_user, :name, :note, :url
  attr_accessible :db_host, :db_name, :db_passwd, :db_port, :db_user, :name, :note, :url, :state, :as => :admin
  validates :db_name, :url, :presence => true

  after_initialize :default_values

  def default_values
    self.db_host ||= '127.0.0.1'
    self.db_port ||= '3306'
    self.db_user ||= 'root'
    self.db_name ||= 'ecstore'
    self.url ||= 'http://'
  end

  state_machine :initial => :normal do
    state :locked

    event :lock do
      transition :normal => :locked
    end

    event :available do
      transition :locked => :normal
    end
  end

  scope :normal, with_state(:normal)
  scope :locked, with_state(:locked)

end
