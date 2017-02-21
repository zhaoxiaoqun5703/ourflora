class FamiliesController < ApplicationController
  before_action :logged_in_user, only: [:new, :show, :edit, :update, :destroy]

  # GET /families
  # GET /families.json
  # CRUD actions are built for this model
  def index
    @families = Family.page(params[:page])
  end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)
    if @family.save
      redirect_to @family
    else
      render 'new'
    end
  end

  def show
    @family = Family.find(params[:id])
  end

  def edit
      @family = Family.find(params[:id])
  end

  def update
    @family = Family.find(params[:id])
    if @family.update_attributes(family_params)
      # Handle a successful update.
      flash[:success] = "Family updated"
      redirect_to @family
    else
      render 'edit'
    end
  end

  def destroy
      Family.find(params[:id]).destroy
      flash[:success] = "Family deleted"
      redirect_to families_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_family
      @family = Family.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_params
      params.require(:family).permit(:name, :phylogeny)
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end


#@families = Family.includes(:species).order(:name).all
#respond_to do |format|
#  format.html {
#    not_found
#  }
#  format.xml { render :xml => @families }
#  format.json {
#    render :json => @families.to_json(include: [:species => {:only => :id}])
#  }
#end
