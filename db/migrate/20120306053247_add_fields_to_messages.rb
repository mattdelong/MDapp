class AddFieldsToMessages < ActiveRecord::Migration
  def change
  	add_column  :messages, :is_archived, :boolean, :default => false
  	add_column  :messages, :is_read, :boolean, :default => false
  	add_column  :messages, :is_private, :boolean, :default => false
  	add_column  :messages, :target_type, :string
  	add_column  :messages, :target_id, :integer
  	add_column  :messages, :user_id, :integer
  	add_column  :messages, :proposal_id, :integer
  	add_column  :messages, :topic_id, :integer
  end
end
