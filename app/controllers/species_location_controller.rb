class SpeciesLocationController < ApplicationController
  before_action :logged_in_user, only: [:new, :show, :edit, :update, :destroy]

  def new
    @location = SpeciesLocation.new
  end

  def create
    @location = SpeciesLocation.new(location_params)
    if @location.save
      redirect_to species_locations_index_path
    else
      render :action => 'new'
    end

  end

  def destroy
    @location = SpeciesLocation.find(params[:id])
    @location.destroy
    flash[:success] = "SpeciesLocation deleted"
    redirect_to species_locations_index_path

  end

  private

    def location_params
      params.require(:species_location_trail).permit(:trail_id, :species_location_id, :species_id, :information, :arborplan_id)
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

end
