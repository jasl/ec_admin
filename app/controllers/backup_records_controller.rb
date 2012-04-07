# -*- encoding : utf-8 -*-
class BackupRecordsController < ApplicationController
  before_filter :covert_param, :only => :fetch
  load_and_authorize_resource :except => :index

  def index
    @backup_records = BackupRecord.page params[:page]
    authorize! :read, @backup_records

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @backup_records }
    end
  end

  def fetch
    #@backup_record = BackupRecord.find params[:backup_record_id]
    @file = "#{Rails.root.to_s}/#{Setting.ec_tools[:backup_dir]}/#{@backup_record.file}.tar.gz"
    send_file @file if File.exist? @file
  end

  def show

    respond_to do |format|
      format.html
      format.json { render json: @backup_record }
    end
  end

  def edit

    respond_to do |format|
      format.html
      format.json { render json: @backup_record }
    end
  end

  def destroy
    @backup_record.destroy

    respond_to do |format|
      format.html { redirect_to backup_records_path }
      format.json { head :no_content }
    end
  end

  def update

    respond_to do |format|
      if @backup_record.update_attributes(params[:backup_record])
        format.html { redirect_to @backup_record, notice: '更新成功。' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @backup_record, status: :unprocessable_entity }
      end
    end
  end

  private

  def covert_param
    unless params.has_key? :id
      params[:id] = params[:backup_record_id] if params.has_key? :backup_record_id
    end
  end
end
