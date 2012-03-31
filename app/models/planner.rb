class Planner < ActiveRecord::Base
  include Commentable,
			Paramable
			
  mount_uploader :logo, LogoUploader
  
  has_many :photos, :class_name => 'PlannerPhoto'
	
  has_many :planner_users
  has_many :users,      :through => :planner_users
  has_many :members,    :through => :planner_users, :source => :user, :conditions => { 'planner_users.role_identifier' => 'member' }
  has_many :employees,  :through => :planner_users, :source => :user, :conditions => { 'planner_users.role_identifier' => 'employee' }
  has_many :providers, :through => :planner_users, :source => :user, :conditions => { 'planner_users.role_identifier' => 'provider' }
 
  has_many :proposals
  
  validates :name,              :presence     => true,
                                :uniqueness   => true,
                                :length       => { :within => 4..40 }
  validates :email,             :presence     => true,
                                :uniqueness   => true
  validates :phone1,            :presence     => true,
                                :length       => { :within => 7..20 }
  validates :location,          :presence     => true
  validates :market_identifier, :presence     => true,
                                :inclusion    => { :in => I18n.t('planner.market_identifiers').keys.map(&:to_s) }
                                
  def self.markets
    I18n.t 'planner.market_identifiers'
  end

  def self.roles
    I18n.t 'planner.role_identifiers'
  end

  def market
    I18n.t "planner.market_identifiers.#{market_identifier}"
  end

  def logo_full
    logo? ? logo : 'planner_460x300.png'
  end

  def logo_thumb
    logo? ? logo.thumb : 'planner_153x100.png'
  end

  def logo_avatar
    logo? ? logo.avatar : 'planner_50x50.png'
  end

  def invite_or_attach_user(role_identifier, attributes)
    user = User.find_by_email(attributes[:email]) || attributes[:email] # && TODO: send an invitation email

    attach_user(user, role_identifier, attributes[:member_title])

    # TODO: remove the confirmation and make the target user to confirm the invite manually
    confirm_user(user, role_identifier)
  end

  def attach_user(user, role_identifier = :member, member_title = '')
    planner_users.create(
      :user_email      => (user.try(:email) || user),
      :role_identifier => role_identifier.to_s,
      :member_title    => member_title,
    ) unless user_meta(user, role_identifier)
  end

  def confirm_user(user, role_identifier = :member)
    user_meta(user, role_identifier).update_attribute(:confirmed, true)
  end

  def update_user(user, role_identifier = :member, attributes = {})
    user_meta(user, role_identifier).update_attributes(attributes)
  end

  def detach_user(user, role_identifier = :member)
    user_meta(user, role_identifier).destroy
  end
  
   def organizer
    members.first
  end

  def user_meta(user, role_identifier = :member)
    planner_users.where(
      :user_email      => (user.try(:email) || user),
      :role_identifier => role_identifier.to_s
    ).first
  end

  def member_title(user, role_identifier = :member)
    user_meta(user, role_identifier).member_title
  end

  def user_role(user)
    I18n.t "planner.role_identifiers.#{user_meta(user).role_identifier}"
  end

  def create_proposal(venues = [], attributes = {}, stage = 'draft', private_message = I18n.t('text.default_text_for_proposal_review'))
    raise Exceptions::NotAllowed if proposals.count >= Settings.planner.proposal.limit

    proposal = proposals.create(attributes)
    update_and_submit_proposal(proposal, venues, attributes, stage)
    send_private_message_to_venues(proposal, venues, private_message) if stage == 'submitted'
    proposal
  end

  def update_proposal(proposal, venues = [], attributes = {}, stage = 'draft', private_message = I18n.t('text.default_text_for_proposal_review'))
    proposal.update_attributes(attributes)
    update_and_submit_proposal(proposal, venues, attributes, stage)
    send_private_message_to_venues(proposal, venues, private_message) if stage == 'submitted'
    proposal
  end

  def all_users
    members + employees + providers 
  end
  
   private

  def update_and_submit_proposal(proposal, venues, attributes, stage)
    proposal.update_attribute(:proposal_stage_identifier, stage)
    proposal.submit(venues)
    proposal
  end

  def send_private_message_to_venues(proposal, venues, private_message)
    [venues].flatten.each do |venue|
      organizer.send_private_message(venue, private_message, :proposal_id => proposal.id)
    end
  end



end
