class VenuesController < ApplicationController
  
  before_filter :authenticate_user!, :only => :new    #device helper
  before_filter :ensure_ownership, :only => [:edit, :destroy]

  def index
    @venues = Venue.all
  end

  def show
    if params[:url]
      @venue = Venue.find_by_url(params[:url])
      if !@venue
	redirect_to venues_path
	return
      end
    elsif params[:id]
      @venue = Venue.find(params[:id])
    end
      
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @venue }
    end
  end


  def new
    @venue = Venue.new
  end

  def edit
    @venue = Venue.find(params[:id])
  end

  def create
    @venue = current_user.venues.build(params[:venue])

    respond_to do |format|
      if @venue.save
        format.html { redirect_to @venue, notice: 'Venue was successfully created.' }
        format.json { render json: @venue, status: :created, location: @venue }
      else
        format.html { render action: "new" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @venue = Venue.find(params[:id])
      if @venue.update_attributes(params[:venue])
        redirect_to([@venue.user, @venue], :notice => 'Your changes have been saved')
      else
        render :action => "edit"
      end
  end

  def destroy
    user = User.find(params[:user_id])
    @venue = user.venues.find(params[:id])
    @venue.destroy
    redirect_to user_venues_url(user)
  end

  def require_ownership
    unless current_user && (@venue == current_user || current_user.role == 2)
      redirect_to venues_path, :notice => 'Only the venue manager can access this page'
      return false
    end
  end

end

