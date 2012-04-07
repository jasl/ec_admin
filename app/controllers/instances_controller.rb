# -*- encoding : utf-8 -*-
class InstancesController < ApplicationController
  load_and_authorize_resource :except => [:index, :clear, :recovery, :reset_passwd, :backup]

  # GET /instances
  # GET /instances.json
  def index
    @instances = Instance.page params[:page]
    authorize! :read, @instances

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @instances }
    end
  end

  # GET /instances/1
  # GET /instances/1.json
  def show
    #@instance = Instance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @instance }
    end
  end

  # GET /instances/new
  # GET /instances/new.json
  def new
    #@instance = Instance.new
    @instance.url = "http://#{request.host}"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @instance }
    end
  end

  # GET /instances/1/edit
  def edit
    #@instance = Instance.find(params[:id])
  end

  # POST /instances
  # POST /instances.json
  def create
    #@instance = Instance.new(params[:instance])

    respond_to do |format|
      if @instance.save
        format.html { redirect_to @instance, notice: '创建成功' }
        format.json { render json: @instance, status: :created, location: @instance }
      else
        format.html { render action: "new" }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /instances/1
  # PUT /instances/1.json
  def update
    #@instance = Instance.find(params[:id])

    respond_to do |format|
      if @instance.update_attributes(params[:instance])
        format.html { redirect_to @instance, notice: '更新成功。' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instances/1
  # DELETE /instances/1.json
  def destroy
    #@instance = Instance.find(params[:id])
    @instance.destroy

    respond_to do |format|
      format.html { redirect_to instances_url }
      format.json { head :no_content }
    end
  end

  def clear
    get_instances.each do |instance|
      authorize! :clear, instance
      instance.do 'clear'
    end
    redirect_to instances_path, :notice => t('messages.enqueue')
  end

  def backup
    get_instances.each do |instance|
      authorize! :clear, instance
      instance.do 'backup'
    end
    redirect_to instances_path, :notice => t('messages.enqueue')
  end

  def reset_passwd
    get_instances.each do |instance|
      authorize! :clear, instance
      instance.do 'reset_passwd'
    end
    redirect_to instances_path, :notice => t('messages.enqueue')
  end

  def recovery
    @instance = Instance.find params[:instance_id]
    authorize! :recovery, Instance

    @instance.do 'recovery', params[:backup_record_id]
    redirect_to instances_path, :notice => t('messages.enqueue')
  end

  private

  def get_instances
    if params.has_key? :instances
      instances = Instance.where :id => params[:instances]
    else
      instances = Instance.where :id => params[:instance_id]
    end
    instances
  end

end
