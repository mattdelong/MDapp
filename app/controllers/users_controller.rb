class UsersController < ApplicationController
  inherit_resources

  has_scope :page, :default => 1

=begin
  def index
    respond_to do |format|
      format.json { render :json => collection.for_auto_suggest }
      format.html { render 'users/_index', :locals => { :meta => {} } }
    end
  end
=end
 	
  def index
    @users = User.all
  end

  def show
  	@user = current_user
    @user = User.find(params[:id])  
  end
  
  def message_inboxes
    message_type = params[:type].try(:to_sym)

    @messages = case message_type
      when :inbox_messages     then current_user.inbox_messages
      when :sent_messages      then current_user.sent_messages
      when :archived_messages  then current_user.archived_messages
      when :inbox_proposals    then current_user.inbox_proposals
      when :sent_proposals     then current_user.sent_proposals
      when :archived_proposals then current_user.archived_proposals
      else redirect_to my_message_inbox_path(:inbox_messages)
    end

    case message_type
      when /_messages/  then render 'message_inboxes'
      when /_proposals/ then render 'proposal_inboxes'
    end
  end
  
private

  def collection
    User.page(params[:page])
  end

  def resource
    if params.key?(:username)
      User.find_by_username(params[:username])
    elsif params.key?(:id)
      super
    else
      current_user
    end
  end

  def target
    params[:target_type].constantize.find(params[:target_id])
  end

end
