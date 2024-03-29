class TranslationsController < ApplicationController
  before_action :set_translation, only: [:show, :edit, :update, :destroy, :vote_up, :vote_down]
  before_action :get_item, except: [:index]
  before_filter :authenticate_user!
  before_filter :access_control_existing, only: [:edit, :update, :destroy]

  # GET /translations
  def index
    @translations = Translation.all
  end

  # GET /translations/1
  def show
  end

  # GET /translations/new
  def new
    @translation = Translation.new
  end

  # GET /translations/1/edit
  def edit
  end

  # POST /translations
  def create
    @translation = Translation.new(translation_params)
    @translation.item_id = @item.id
    #@translation.score = 0

    respond_to do |format|
      if @translation.save
        format.html { redirect_to item_translation_path(@item, @translation), notice: 'Translation was successfully created.' }
      else
        format.html { render action: 'new' }
      end
      format.js
    end
  end

  # PATCH/PUT /translations/1
  def update
    respond_to do |format|
      if @translation.update(translation_params)
        format.html { redirect_to @translation, notice: 'Translation was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /translations/1
  def destroy
    @translation.destroy
    respond_to do |format|
      format.html { redirect_to translations_url }
    end
  end

  def vote_up
    @translation.vote_up(current_user)
    respond_to do |format|
      format.js
    end
  end

  def vote_down
    @translation.vote_down(current_user)
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_translation
      @translation = Translation.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def get_item
      if params.key?(:item_id)
        @item = Item.find(params[:item_id])
      else
        @item = Item.find(@translation.item_id)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def translation_params
      params.require(:translation).permit(:item_id, :language_id, :user_id, :value, :score)
    end
    
    def access_control_existing
      redirect_not_authorized unless @translation.user_id == current_user.id
    end
end
