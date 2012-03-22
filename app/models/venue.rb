class Venue < ActiveRecord::Base
	
	belongs_to :user
	has_many :requests, :dependent => :destroy, :order => 'created_at desc'
    has_many :rfps, :through => :requests

	
	attr_accessible :user_id, 
					:company_name, 
					:address, 
					:city, 
					:state,
					:zip

end
