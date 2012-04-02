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
    state :error

    event :lock do
      transition :normal => :locked
    end

    event :error do
      transition [:normal, :locked] => :error
    end

    event :available do
      transition [:locked, :error] => :normal
    end
  end

  scope :normal, with_state(:normal)
  scope :locked, with_state(:locked)
  scope :error, with_state(:error)

  def do method
    self.lock

    case method
      when :clear
        self.clear
      when :backup
        self.backup
      when :reset_passwd
        self.reset_passwd
      else
        self.available
    end
  end

  def clear
    sleep(5)

    self.available
  end

  def backup
    sleep(5)

    self.available
  end

  def reset_passwd
    sleep(5)

    self.available
  end

  handle_asynchronously :clear, :queue => 'instances'
  handle_asynchronously :backup, :queue => 'instances'
  handle_asynchronously :reset_passwd, :queue => 'instances'

end
