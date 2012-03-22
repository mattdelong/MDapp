require 'digest/md5'
class User < ActiveRecord::Base

  devise :database_authenticatable, 
  		 :registerable,
         :recoverable, 
         :rememberable, 
         :trackable, 
         :validatable
         
  attr_readonly :messages_count

  attr_accessible :username,
                  :name,
                  :email,
                  :role,
                  :password,
                  :password_confirmation,
                  :remember_me
      
  #associations            
  has_many  :messages, :order => 'created_at DESC'
  has_many  :venues
  has_many  :rfps
  has_one   :planner_profile
  
  #validations                 
  validates :email,    :presence 	 => true
  validates :name,     :presence     => true,
                       :length       => { :within => 1..30 }
                       
  #scope  :planners,		where { planner_profile.user_id != nil}
                       
  #messaging system             
  def incoming_messages
    comments.private_only.topics
  end

  def outgoing_messages
    messages.on_users.private_only.topics
  end

  def inbox_messages
    incoming_messages.without_proposal.unarchived
  end

  def sent_messages
    outgoing_messages.without_proposal
  end

  def archived_messages
    incoming_messages.without_proposal.archived
  end

  def inbox_proposals
    incoming_messages.with_proposal.unarchived
  end

  def sent_proposals
    outgoing_messages.with_proposal
  end

  def archived_proposals
    incoming_messages.with_proposal.archived
  end

  def has_new_messages?
    inbox_messages.unread.any?
  end

  def has_new_proposals?
    inbox_proposals.unread.any?
  end

  def is_admin?
    !!is_admin
  end
  
  def is_planner?
  	planner_profile.present?
  end

  				  
  
  
end
