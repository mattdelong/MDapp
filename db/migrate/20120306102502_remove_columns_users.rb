class RemoveColumnsUsers < ActiveRecord::Migration
  def up
  	remove_column :users, :company
  	remove_column :users, :title
  	remove_column :users, :past_events
  	remove_column :users, :twitter
  	remove_column :users, :linkedin
  	remove_column :users, :facebook
  	remove_column :users, :introduction
  	remove_column :users, :location
  end

  def down
  end
end
