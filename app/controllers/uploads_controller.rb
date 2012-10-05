class UploadsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :delete]

  def index
    @uploads = Upload.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @uploads }
    end
  end

  def new
    @upload = Upload.new
  end

  def show
    @upload = Upload.find_by_id(params[:id])
  end

  def create
    @upload = Upload.new(params[:upload])
    respond_to do |format|
      if @upload.process
        format.html { redirect_to @upload, notice: 'Upload was successfully created.' }
        format.json { render json: @upload, status: :created, location: @upload }
      else
        format.html { render action: "new" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy

    respond_to do |format|
      format.html { redirect_to uploads_url }
      format.json { head :no_content }
    end
  end
end
