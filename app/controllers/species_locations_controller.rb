class SpeciesLocationsController < ApplicationController
  before_action :logged_in_user, only: [:new, :show, :edit, :update, :destroy]

  #for showing all species coordinates
  def index
    @locations = SpeciesLocation.all
  end

  def new
    @location = SpeciesLocation.new
  end

  #for creating new species coordinate entry
  def create
    @location = SpeciesLocation.new(location_params)
    if @location.save
      redirect_to species_location_trails_index_path
    else
      render :action => 'new'
    end

  end

  #for deleteing an existing entry
  def destroy
    @location = SpeciesLocation.find(params[:id])
    @location.destroy
    flash[:success] = "SpeciesLocation deleted"
    redirect_to species_locations_index_path

  end

  private
    #species_location has important fields: lat, lon, and information, just include these for creating a new species_location entry
    def location_params
      params.require(:species_location).permit(:lat, :lon, :information, :arborplan_id)
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

  end
