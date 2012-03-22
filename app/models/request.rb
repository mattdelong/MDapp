class Request < ActiveRecord::Base
	
	belongs_to :venue
	belongs_to :rfp
	
	after_create :send_rfp_notification
	
private
  
  def send_rfp_notification
    Notification.deliver_rfp_notification(self) if venue and venue.user
  end

end
