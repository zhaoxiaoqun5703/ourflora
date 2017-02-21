class SpeciesController < ApplicationController
  before_action :set_species, only: [:show]
  before_action :logged_in_user, only: [:new, :show, :edit, :update, :destroy]
  # GET /species
  # GET /species.json


  #This class has also the CRUD actions.
  def index
    @species = Species.eager_load(:family, :species_locations, :images).order('families.name')
    respond_to do |format|
      format.html {
        not_found
      }
      format.xml { render :xml => @species }
      format.json {
         render :template => 'species/index.json'
      }
    end
  end

  def index
    @sps = Species.page(params[:page])
  end

  def show
    respond_to do |format|
      # If they're looking at the interface and they specify a species, load the index anyway but highlight the selected species
      format.html {
        @families = Family.includes(:species).order(:name).load
        @families = @families.to_json(include: [:species => {:only => :id}])

        # Render list of all trails and species and push to the view as JSON so that backbone can use it
        @species = Species.eager_load(:family, :species_locations, :images).where("species_locations.removed = false")

        @trails = Trail.includes(:species_locations).all
        @trails = @trails.to_json(include: [:species_locations => {:only => [:id, :lat, :lon]}])

        @page_title = @species_selected.genusSpecies

        # Initialise a markdown parser that we can use in the view to well, parse markdown
        @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
        # Grab the about page content to render
        @page_content = PageContent.first

        render 'map/index'
      }
    end
  end

  def show
    @species = Species.friendly.find(params[:id])
  end


  #the new species is now created by one image and one coordinate, if more needed to be created,
  #change the number accordingly.
  def new
    @species = Species.new
    for i in 0..0
      @species.species_locations.build
    end
    for i in 0..0
      @species.images.build
    end
  end

  def create
    @species = Species.new(species_params)
    if @species.save
      flash[:success] = "Species created"
      redirect_to @species
    else
      render :action => 'new'
    end
  end

  def destroy
    #remove associated images and species_locations before destorying the species object itself
      @species = Species.friendly.find(params[:id])
      @species.species_locations.clear
      @species.images.clear
      @species.destroy
      flash[:success] = "Species deleted"
      redirect_to species_index_path
  end


  def edit
      @species = Species.friendly.find(params[:id])
  end

  def update
    @species = Species.find(params[:id])
    if @species.update(params[:species])
      # Handle a successful update.
      flash[:success] = "Species updated"
      redirect_to @species
    else
      render 'edit'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_species
      @species_selected = Species.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def species_params
      params.require(:species).permit(:family_id, :genusSpecies, :commonName, :indigenousName, :species_locations_attributes => [:lat, :lon, :information, :arborplan_id], :images_attributes => [:genusSpecies, :image])
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
