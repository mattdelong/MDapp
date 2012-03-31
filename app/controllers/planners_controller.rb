class PlannersController < ApplicationController
	inherit_resources

  belongs_to :user, :optional => true

  has_scope :page, :default => 1

  before_filter :hide_sidebar, :only => [:show, :edit]
  after_filter  :attach_organizer_to_planner, :only => :create

  def profile_details
    render :partial => 'planners/profile_details', :locals => { :planner => resource }
  end

  def profile_team
    render :partial => 'planners/profile_team', :locals => { :planner => resource }
  end

  def photos
    render :partial => 'planners/photos', :locals => { :planner => resource }
  end

  def upload_photos

  end

  def attach_user
    if request.post?
      result = resource.invite_or_attach_user(params[:role_identifier], params[:attributes])

      respond_to do |format|
        format.json { render :json => result }
        format.html { redirect_to resource_path(resource) }
      end
    end
  end

  def update_user
    user = User.find(params[:uid])

    if request.post?
      result = resource.update_user(user, params[:role_identifier], params[:attributes])

      respond_to do |format|
        format.json { render :json => result }
        format.html { redirect_to resource_path(resource) }
      end
    else
      @user_meta = resource.user_meta(user)
    end
  end

  def detach_user
    if request.post?
      result = resource.detach_user(User.find(params[:uid]), params[:role_identifier])

      respond_to do |format|
        format.json { render :json => result }
        format.html { redirect_to resource_path(resource) }
      end
    end
  end

  private

  def attach_organizer_to_planner
    if resource.persisted?
      resource.attach_user(parent, :member, t('label.organizer'))
      resource.confirm_user(parent)
    end
  end

end
