class GardensController < ApplicationController

  #GET  /gardens/:id
  def show
    @garden = Garden.find(params[:id])
    authorize @garden
  end

  #GET  /gardens/new
  def new
    @garden = Garden.new
    authorize @garden
  end

  # POST /gardens
  def create
    # make a new garden with name and address specified by current_user
    @garden = Garden.new(safe_params)
    authorize @garden
    @garden.user = current_user
    @garden.grid_cell_size_mm = 100
    # check the garden address gives valid coordinates
    # this is done using custom validation function which attempts to geocode it
    @garden.valid?
    unless @garden.errors.details[:address].empty? && @garden.errors.messages[:address].empty?
      # garden address is invalid, have user try resubmit a new address
      flash[:notice] = @garden.errors.messages[:address].first
      render :new
    else
      # garden address is valid and has been geocoded
      # use geocoded coordinates to locate a weather station
      @garden.weather_station = WeatherStation.find_by_coords(@garden.lat, @garden.lon)
      # call final validation on garden before saving
      if @garden.save
        flash[:notice] = 'Created new garden!'
        # go to garden show page
        redirect_to garden_path(@garden)
      else
        render :new
      end
    end
  end

  private

  def safe_params
    params.require(:garden).permit(:name, :address)
  end
end
