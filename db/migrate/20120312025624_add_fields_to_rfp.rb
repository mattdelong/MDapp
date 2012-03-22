class AddFieldsToRfp < ActiveRecord::Migration
  def change
  	add_column  :rfps, :title, :string
  	add_column  :rfps, :response_by, :date
  	add_column  :rfps, :decision_by, :date
  	add_column  :rfps, :first_name, :string
  	add_column  :rfps, :last_name, :string
  	add_column  :rfps, :email, :string
  	add_column  :rfps, :phone, :string
  	add_column  :rfps, :company, :string
  	add_column  :rfps, :third_party_planner, :boolean, :default => false
  	add_column  :rfps, :event_type, :string
  	add_column  :rfps, :start_date, :date
  	add_column  :rfps, :end_date, :date
  	add_column  :rfps, :dates_flexible, :boolean, :default => false
  	add_column  :rfps, :total_guests, :integer
  	add_column  :rfps, :event_description, :text
  	
  end
end


add_column	:planner_profile,  :user_id, :integer
add_column  :planner_profile,  :company, :string
add_column  :planner_profile,  :title, :string
add_column  :planner_profile,  :description, :text
add_column  :planner_profile,  :linkedin, :string
add_column  :planner_profile,  :twitter, :string
add_column  :planner_profile,  :facebook, :string