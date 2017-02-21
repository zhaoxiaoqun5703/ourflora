class TrailsController < ApplicationController
  before_action :set_trail, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :destroy]


  #for the create action
  def new
    @trail = Trail.new
  end

  #redirect the user to the 'contract' after creating a new trail
  def create
    @trail = Trail.new(trail_params)
    if @trail.save
      redirect_to species_location_trails_index_path
    else
      render :action => 'new'
    end

  end

  #for destroying a trail entry
  def destroy
    @trail = Trail.find(params[:id])
    @trail.destroy
    flash[:success] = "Trail deleted"
    redirect_to trails_index_path

  end



  # GET /trails
  # GET /trails.json
  def index
    @trails = Trail.includes(:species).all
    respond_to do |format|
      format.html {
        not_found
      }
      format.xml { render :xml => @trails }
      format.json {
        render :json => @trails.to_json(include: [:species => {:only => :id}])
      }
    end
  end

  def show
    respond_to do |format|
      # If they're looking at the interface and they specify a trail, load the index anyway but highlight the selected trail
      format.html {
        @families = Family.includes(:species).order(:name).load
        @families = @families.to_json(include: [:species => {:only => :id}])

        # Render list of all trails and species and push to the view as JSON so that backbone can use it
        @species = Species.eager_load(:family, :species_locations, :images)

        @trails = Trail.includes(:species_locations).all
        @trails = @trails.to_json(include: [:species_locations => {:only => [:id, :lat, :lon]}])

        @page_title = @trail_selected.name

        # Initialise a markdown parser that we can use in the view to well, parse markdown
        @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
        # Grab the about page content to render
        @page_content = PageContent.first

        render 'map/index'
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trail
      puts params[:id]
      @trail_selected = Trail.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only alow the white list through.
    # the allowed parameters are set to be: name and information, change it if suitable
    def trail_params
      params.require(:trail).permit(:name, :information)
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
