class SpeciesLocationTrailsController < ApplicationController
  before_action :logged_in_user, only: [:new, :show, :edit, :update, :destroy]


  def index
    @contracts = SpeciesLocationTrail.all
  end

  def new
    @contract = SpeciesLocationTrail.new
  end

  def show
    @contract = SpeciesLocationTrail.find(params[:id])
  end

  def edit
    @contract = SpeciesLocationTrail.find(params[:id])
  end

  def update
    @contract = SpeciesLocationTrail.find(params[:id])
    if @contract.update(contract_params)
      redirect_to species_location_trails_index_path
    else
      render :action => 'edit'
    end
  end

  def create
    @contract = SpeciesLocationTrail.new(contract_params)
    if @contract.save
      redirect_to species_location_trails_index_path
    else
      render :action => 'new'
    end

  end

  def destroy
    @contract = SpeciesLocationTrail.find(params[:id])
    @contract.destroy
    flash[:success] = "SpeciesLocationTrail deleted"
    redirect_to species_location_trails_index_path

  end



  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def contract_params
      params.require(:species_location_trail).permit(:trail_id, :species_location_id)
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
