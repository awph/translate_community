class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :get_project
  before_filter :authenticate_user!
  before_filter :access_control, only: [:edit, :update, :destroy, :new, :create]

  # GET /items
  def index
    @items = Item.all
  end

  # GET /items/1
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
    @item.project_id = @project.id
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to project_path(@project), notice: 'Item was successfully created.' }
      else
        format.html { redirect_to project_path(@project), alert: 'Creating the new item failed!' }
      end
    end
  end

  # PATCH/PUT /items/1
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def get_project
      if params.key?(:project_id)
        @project = Project.find(params[:project_id])
      else
        @project = Project.find(@item.project_id)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:project_id, :key)
    end
    
    def access_control
      redirect_not_authorized unless @project.user_id == current_user.id
    end
end
