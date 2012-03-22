class RfpsController < ApplicationController
	
  before_filter :ensure_ownership, :only => [:show, :edit, :destroy]
  

	
  def new
    @rfp = Rfp.new(:venue_ids => params[:venue_ids], :budget => params[:budget])
    if params[:venue_id]
      @rfp.venues << venue.find_by_id(params[:venue_id])
    end
    @venues = @rfp.venues
    if @venues.empty?
      flash[:error] = t('rfp.venue_required')
      redirect_to new_rfp_path
    elsif @venues.size > 3
      flash[:error] = t('rfp.three_venue_max')
      redirect_to new_rfp_path
    end
  end
  
  
  def show
    @rfp = Rfp.find(params[:id])
  end
  
  
  def create
    @rfp = current_user.rfps.build(params[:rfp])

    respond_to do |format|
      if @rfp.save
        format.html { redirect_to @rfp, notice: 'RFP was successfully created.' }
        format.json { render json: @rfp, status: :created, location: @rfp }
      else
        format.html { render action: "new" }
        format.json { render json: @rfp.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    user = User.find(params[:user_id])
    @rfp = user.rfps.find(params[:id])
    @rfp.destroy
    redirect_to user_rfps_url(user)
  end

end
