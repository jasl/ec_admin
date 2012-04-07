# -*- encoding : utf-8 -*-
class Instance < ActiveRecord::Base

  class ExistPathValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless File.directory? "#{Setting.ec_tools[:http_dir]}/#{value}"
        record.errors.add attribute, "#{attribute}必须是存在的目录"
      end
    end
  end

  attr_accessible :db_host, :db_name, :db_passwd, :db_port, :db_user, :path, :name, :note, :url
  attr_accessible :db_host, :db_name, :db_passwd, :db_port, :db_user, :path, :name, :note, :url, :state, :as => :admin

  validates :path, :db_name, :url, :presence => true
  #validates :path, :exist_path => true

  after_initialize :default_values

  def default_values
    self.db_host ||= '127.0.0.1'
    self.db_port ||= '3306'
    self.db_user ||= 'root'
    self.db_name ||= 'ecstore'
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

  def do(method, value=nil)
    self.lock

    if method == 'clear'
      self.clear
    elsif method == 'backup'
      self.backup
    elsif method == 'reset_passwd'
      self.reset_passwd
    elsif method == 'recovery'
      self.recovery value
    end
  end

  def clear
    EcTools.clear self.db_name, self.path
    self.available
    #begin
    #  EcTools.clear self.db_name, self.path
    #  self.available
    #rescue => ex
    #  self.error
    #  logger.error ex
    #end
  end

  def backup
    EcTools.backup self.db_name, self.path
    self.available
  end

  def reset_passwd
    begin
    #EcTools.reset_passwd self.db_host, self.db_port, self.db_name, self.db_user, self.db_passwd
      self.available
    rescue => ex
      self.error
      logger.error ex
    end
  end

  def recovery(record_id = nil)
    EcTools.recovery self.db_name, self.path, record_id
    self.available
    #begin
    #  #throw 'record_id is nil' if record_id.nil?
    #  EcTools.recovery self.db_name, self.path, record_id
    #  self.available
    #rescue => ex
    #  self.error
    #  logger.error ex.message
    #end
  end

  handle_asynchronously :clear, :queue => 'instances'
  handle_asynchronously :backup, :queue => 'instances'
  handle_asynchronously :reset_passwd, :queue => 'instances'
  handle_asynchronously :recovery, :queue => 'instances'

end
