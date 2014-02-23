require 'nokogiri'

class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :upload_items, :destroy, :upload_items]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload_items
    uploaded_io = params[:project][:new_items]
    contents = uploaded_io.read
    items = case uploaded_io.content_type
              when 'text/xml' then extract_items_xml_android(contents)
              when 'application/octet-stream' then extract_items_strings_ios(contents)
            end
    items.each do |name, value|
      item = Item.where(project_id: @project.id, key: name).take
      if !item
        item = Item.create(project_id: @project.id, key: name)
      end

      translation = Translation.where(item_id: item.id, language_id: 1, value: value)
      if translation
        Translation.create(item_id: item.id, language_id: 1, user_id: 1, value: value, score: 0) # TODO: parent
      else
        Translation.create(item_id: item.id, language_id: 1, user_id: 1, value: value, score: 0)
      end
    end
    p formats
    p uploaded_io.content_type
    respond_to do |format|
      format.html { redirect_to @project }
      format.js
    end
  end

  # Extract and return the items of a xml file used in Android development
  # The "string" nodes contains all info (name and value)
  # Return a hash of all items
  # https://github.com/sparklemotion/nokogiri/wiki/Cheat-sheet
  def extract_items_xml_android(xml_content)
    xml = Nokogiri::XML.parse(xml_content)
    strings = xml.xpath('//string')
    items = Hash.new
    strings.each do |string|
      name = string.attributes['name'].value
      value = string.children.text
      items[name] = value
    end
    items
  end

  # iOS
  def extract_items_strings_ios(contents)
    items = Hash.new
    contents.split("\n").each do |line|
      match = line.match(/^"(.+)"[ ]*[=][ ]*"(.+)";$/)
      if match
        name = match[1]
        value = match[2]
        items[name] = value
      end
    end
    items
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:user_id, :name, :description)
    end
end
