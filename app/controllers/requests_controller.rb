class RequestsController < ApplicationController
	
	before_filter :ensure_ownership
	
	
  def index
    @requests = current_user.venue.requests.paginate(:page => params[:page])
  end
  
  def show
  	@request = Request.find(params[:id])
    @request.update_attribute(:unread, false) if @request.unread?
    @rfp = @request.rfp
  end
  
  def destroy
  	@request = Request.find(params[:id])
	@request.destroy 
	redirect_to requests_path, :notice => t('message.request_deleted')
  end

end
