class Proposal < ActiveRecord::Base
	
  has_many                :messages
  belongs_to              :planner
  has_and_belongs_to_many :venues, :join_table => :proposal_for_venues, :class_name => 'User'
  
  validates :event_title,                          :presence     => true,
                                                   :length       => { :within => 3..140 }
  validates :event_organizer,                      :presence     => true,
                                                   :length       => { :within => 5..80 }
  validates :event_type,             			   :presence     => true
  validates :event_frequency,  					   :presence     => true
  validates :event_objectives,             		   :presence     => true,
  												   :length       => { :within => 3..140 }
  validates :description,                  		   :presence     => true,
                                                   :length       => { :within => 10..400 }
  validates :budget_amount,            			   :presence     => true,
                                                   :inclusion    => { :in => Settings.currencies }
  validates :start_date,          				   :presence     => true
  validates :end_date,         					   :presence     => true
  validates :response_by,            			   :presence     => true

  scope :draft,     where(:proposal_stage_identifier => 'draft')
  scope :submitted, where(:proposal_stage_identifier => 'submitted')

  before_create :default_proposal_stage_identifier

  def self.stages
    I18n.t 'planner.proposal_stage_identifiers'
  end

  def stage
    I18n.t "planner.proposal_stage_identifiers.#{proposal_stage_identifier}"
  end

  def submit(venues)
    self.venues = [venues].flatten
  end

  private

  def default_proposal_stage_identifier
    self.proposal_stage_identifier = 'draft'
  end
end
