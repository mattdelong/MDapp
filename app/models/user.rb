require 'digest/md5'

class User < ActiveRecord::Base
	include Commentable

  devise :database_authenticatable, 
  		 :registerable,
         :recoverable, 
         :rememberable, 
         :trackable, 
         :validatable

  attr_accessor   :login
  attr_accessible :login,
  				  :email, 
  				  :name,
  				  :username,
  				  :password, 
  				  :password_confirmation, 
  				  :remember_me,
  				  :role
  				  
  has_many :messages, :order => 'created_at DESC'

  has_one  :venue_profile
  				  
  has_and_belongs_to_many :proposals, :join_table => :proposal_for_venues
  
  has_many :planner_users, :foreign_key => 'user_email', :primary_key => 'email'
  has_many :planners, :through => :planner_users

  				  
  validates :username, :presence     => true,
                       :uniqueness   => { :case_sensitive => false },
                       :length       => { :within => 4..20 },
                       :format       => { :with => /^[A-Za-z0-9_]+$/ }
  validates :name,     :presence     => true,
                       :length       => { :within => 4..30 }

  scope :new_users,     joins { [planner_users.outer, venue.outer] }.where { (planner_users.user_email == nil) & (venue.user_id == nil) }
  scope :planners, 		joins { planner_users }.where { planner_users.user_email != nil }
  scope :venues,     	joins { venue_profile }.where { venue_profile.user_id != nil }
              
  before_save :email_nomarlisation

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
  
  def is_new_user?
    !is_planner? && !is_venue? && !is_provider?
  end

  def is_planner?
    user.role == 'planner'
  end

  def is_venue?
    user.role == 'venue'
  end
  
  def is_provider?
  	user.role == 'provider'
  end

  def avatar(size = 80)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?s=#{size}"
  end
  
  def send_private_message(target_user, content, extras = {})
    messages.create!({
      :content     => content,
      :is_private  => true,
      :target_id   => target_user.id,
      :target_type => 'User'
    }.merge(extras)) && reload
  end

  def reply_private_message(topic, content, extras = {})
    messages.create!({
      :content     => content,
      :is_private  => true,
      :target_id   => topic.user.id,
      :target_type => 'User',
      :topic_id    => topic.id
    }.merge(extras)) && reload
  end
  
  def add_micro_post(content)
    unless content.blank?
      messages.create(:content => content) && reload
      true
    else
      false
    end
  end

  def micro_posts
    messages.micro_posts
  end

  protected
  
  # Devise's support for login using the :login virtual attribute
  class << self
    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login      = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    end

    def send_reset_password_instructions(attributes={})
      recoverable = find_recoverable_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
      recoverable.send_reset_password_instructions if recoverable.persisted?
      recoverable
    end

    def find_recoverable_or_initialize_with_errors(required_attributes, attributes, error=:invalid)
      (case_insensitive_keys || []).each { |k| attributes[k].try(:downcase!) }

      attributes = attributes.slice(*required_attributes)
      attributes.delete_if { |key, value| value.blank? }

      if attributes.size == required_attributes.size
        if attributes.has_key?(:login)
           login = attributes.delete(:login)
           record = find_record(login)
        else
          record = where(attributes).first
        end
      end

      unless record
        record = new

        required_attributes.each do |key|
          value = attributes[key]
          record.send("#{key}=", value)
          record.errors.add(key, value.present? ? error : :blank)
        end
      end
      record
    end

    def find_record(login)
      where(["username = :value OR email = :value", { :value => login }]).first
    end
  end

  private

  def email_nomarlisation
    self.email = email.strip.downcase
  end

end
