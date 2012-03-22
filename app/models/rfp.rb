class Rfp < ActiveRecord::Base
	
	belongs_to :user
	has_many :requests, :dependant => :destroy
	has_many :venues, :through => :requests
	
	attr_accessible :user_id, 
					:title,
					:first_name,
					:last_name,
					:email,
					:phone
	 
end
