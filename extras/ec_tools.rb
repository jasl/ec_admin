# -*- encoding : utf-8 -*-
require 'fileutils'
class EcTools
  TMP_DIR = "#{::Rails.root.to_s}/tmp/files"

  def EcTools.clear(db_name, path)
    file = 'init'

    Dir.mkdir TMP_DIR unless Dir.exist? TMP_DIR

    backup_dir = "#{::Rails.root.to_s}/#{Setting.ec_tools[:backup_dir]}"

    commands = ["tar -zxf #{backup_dir}/#{file}.tar.gz -C #{TMP_DIR}",
                "#{Setting.ec_tools[:mysql_path]}/mysql -u #{Setting.ec_tools[:db_sa]}#{" -p#{Setting.ec_tools[:db_passwd]}" unless Setting.ec_tools[:db_passwd].blank? } #{db_name} < #{TMP_DIR}/#{file}/db.sql",
                "rm -rf #{Setting.ec_tools[:http_dir]}/#{path}/data",
                "rm -rf #{Setting.ec_tools[:http_dir]}/#{path}/themes",
                "cp -rf #{TMP_DIR}/#{file}/data #{Setting.ec_tools[:http_dir]}/#{path}",
                "cp -rf #{TMP_DIR}/#{file}/themes #{Setting.ec_tools[:http_dir]}/#{path}",
                "cp -rf #{TMP_DIR}/#{file}/public #{Setting.ec_tools[:http_dir]}/#{path}",
                "find #{Setting.ec_tools[:http_dir]}/#{path}/data -exec chmod 777 {} \\;",
                "find #{Setting.ec_tools[:http_dir]}/#{path}/themes -exec chmod 777 {} \\;",
                "find #{Setting.ec_tools[:http_dir]}/#{path}/public -exec chmod 777 {} \\;",
                "rm -rf #{TMP_DIR}/#{file}"]
    commands.each do |cmd|
      raise "Run error: #{cmd}" unless system(cmd)
    end
  end

  def EcTools.backup(db_name, path, name = nil)
    Dir.mkdir TMP_DIR unless Dir.exist? TMP_DIR

    name ||= db_name
    backup_name = "#{Time.now.strftime("%Y%m%d%H%M%S")}_#{name}"
    backup_dir = "#{::Rails.root.to_s}/#{Setting.ec_tools[:backup_dir]}"

    Dir.mkdir "#{TMP_DIR}/#{backup_name}" unless Dir.exist? "#{TMP_DIR}/#{backup_name}"

    commands = ["#{Setting.ec_tools[:mysqldump_path]}/mysqldump -u #{Setting.ec_tools[:db_sa]}#{" -p#{Setting.ec_tools[:db_passwd]}" unless Setting.ec_tools[:db_passwd].blank? } #{db_name} > #{TMP_DIR}/#{backup_name}/db.sql",
           "cp -fa #{Setting.ec_tools[:http_dir]}/#{path}/data #{TMP_DIR}/#{backup_name}/",
           "cp -fa #{Setting.ec_tools[:http_dir]}/#{path}/themes #{TMP_DIR}/#{backup_name}/",
           "cp -fa #{Setting.ec_tools[:http_dir]}/#{path}/public #{TMP_DIR}/#{backup_name}/",
           "cd #{TMP_DIR} && tar -zcf #{backup_dir}/#{backup_name}.tar.gz #{backup_name}",
           "rm -rf #{TMP_DIR}/#{backup_name}"]

    commands.each do |cmd|
      raise "Run error: #{cmd}" unless system(cmd)
    end
    BackupRecord.create :name => db_name,
                        :file => backup_name

  end

  def EcTools.recovery(db_name, path, record_id)
    file = BackupRecord.find(record_id).file

    Dir.mkdir TMP_DIR unless Dir.exist? TMP_DIR

    backup_dir = "#{::Rails.root.to_s}/#{Setting.ec_tools[:backup_dir]}"

    commands = ["tar -zxf #{backup_dir}/#{file}.tar.gz -C #{TMP_DIR}",
                "#{Setting.ec_tools[:mysql_path]}/mysql -u #{Setting.ec_tools[:db_sa]}#{" -p#{Setting.ec_tools[:db_passwd]}" unless Setting.ec_tools[:db_passwd].blank? } #{db_name} < #{TMP_DIR}/#{file}/db.sql",
                "rm -rf #{Setting.ec_tools[:http_dir]}/#{path}/data",
                "rm -rf #{Setting.ec_tools[:http_dir]}/#{path}/themes",
                "rm -rf #{Setting.ec_tools[:http_dir]}/#{path}/public",
                "cp -rf #{TMP_DIR}/#{file}/data #{Setting.ec_tools[:http_dir]}/#{path}",
                "cp -rf #{TMP_DIR}/#{file}/themes #{Setting.ec_tools[:http_dir]}/#{path}",
                "cp -rf #{TMP_DIR}/#{file}/public #{Setting.ec_tools[:http_dir]}/#{path}",
                "find #{Setting.ec_tools[:http_dir]}/#{path}/data -exec chmod 777 {} \\;",
                "find #{Setting.ec_tools[:http_dir]}/#{path}/themes -exec chmod 777 {} \\;",
                "find #{Setting.ec_tools[:http_dir]}/#{path}/public -exec chmod 777 {} \\;",
                "rm -rf #{TMP_DIR}/#{file}"]
    commands.each do |cmd|
      raise "Run error: #{cmd}" unless system(cmd)
    end
  end

  #def EcTools.reset_passwd(db_user, db_port, db_name, db_user, db_passwd)
  #
  #end
end