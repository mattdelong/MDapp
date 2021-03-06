class ProposalsController < ApplicationController
  inherit_resources

  belongs_to :planner

  def create
    parent.create_proposal(venues, params[:proposal], proposal_stage)
    show_flash_message
    redirect_to parent_path
  end

  def update
    deny_access && return unless resource.proposal_stage_identifier == 'draft'

    parent.update_proposal(resource, venues, params[:proposal], proposal_stage)
    show_flash_message
    redirect_to parent_path
  end

  private

  def venues
    User.find(params[:venues].split(',')) if params[:venues]
  end

  def proposal_stage
    params[:commit] == t('label.save_draft') ? 'draft' : 'submitted'
  end

  def show_flash_message
    flash[:success] = case proposal_stage
      when 'draft'     then t('message.proposal_saved')
      when 'submitted' then t('message.proposal_submitted')
    end
  end

end
