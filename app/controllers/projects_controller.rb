require 'nokogiri'
require 'zip'

class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :upload_items, :destroy, :upload_items, :download_android, :download_ios]
  before_filter :authenticate_user!

  # GET /projects
  # GET /projects.json
  def index
    if params[:user_id].nil?
      @projects = Project.all
    else
      @projects = Project.where(user_id: params[:user_id])
    end
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
    @project = Project.new(project_params.merge(:user_id => current_user.id))
    @project.language_ids = params[:project][:language_ids]

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
    @project.language_ids = params[:project][:language_ids]
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
        Translation.create(item_id: item.id, language_id: 1, user_id: current_user.id, value: value)
      else
        Translation.create(item_id: item.id, language_id: 1, user_id: current_user.id, value: value)
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

  def fetch_translations
    translations = Hash.new
    @project.items.each do |item|
      key = item.key
      item.translations.each do |translation|
        code = translation.language.code
        translations[code] = Hash.new if translations[code].nil?
        translations[code][key] = Hash.new if translations[code][key].nil?
        score = translations[code][key][:score]
        if score.nil? or score < translation.score
          translations[code][key][:score] = translation.score
          translations[code][key][:value] = translation.value
        end
      end
    end
    translations
  end

  def create_files(translations)
    translations.each do |language, translation|
      translations[language][:file] = Tempfile.new(language.to_s)
    end
    translations
  end

  def fill_file_android(language, translations)
    translations[:filename] = "values-" + language.to_s + "/strings.xml"
    file = translations[:file]

    builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
      xml.resources {
        translations.each do |key, value|
          unless key == :file or key == :filename
            xml.string_('name' => key) {
              xml.text(value[:value])
            }
          end
        end
      }
    end

    file.puts builder.to_xml

    file.close
  end

  def fill_file_ios(language, translations)
    translations[:filename] = language.to_s + ".lproj/" + "Localizable.strings"
    file = translations[:file]

    # Header
    file.puts "/*"
    file.puts "   Localizable.strings"
    file.puts "   " + @project.name
    file.puts ""
    file.puts "   Created on Translate Community on " + Time.new.strftime("%d.%m.%y")
    file.puts "*/"
    file.puts ""

    # Content
    translations.each do |key, value|
      unless key == :file or key == :filename
          file.puts "\"" + key + "\" = \"" + value[:value] + "\";"
      end
    end

    file.close
  end

  def create_zip(translations)
    zip_file_path = Dir::tmpdir + "/" + Dir::Tmpname.make_tmpname([@project.name, '.zip'], nil)

    Zip::File.open(zip_file_path, Zip::File::CREATE) do |zipfile|
      translations.each do |language, translation|
        zipfile.add(translation[:filename], translation[:file].path)
      end
    end

    zip_file_path
  end

  def download(type)
    translations = fetch_translations
    translations = create_files(translations)
    translations.each do |language, translation|
      case type
        when :ios
          fill_file_ios(language, translation)
        when :android
          fill_file_android(language, translation)
      end
    end

    zip_file_path = create_zip(translations)

    send_file zip_file_path, :type => 'application/zip', :disposition => 'attachment', :filename => @project.name + ".zip"
  end

  def download_android
    download(:android)
  end

  def download_ios
    download(:ios)
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
      @project = Project.includes(:items => :translations).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:user_id, :name, :description, :language_ids)
    end
end
