class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer
    add_column :users, :complete_profile, :boolean 
    add_column :users, :twitter, :string
    add_column :users, :linkedin, :string
    add_column :users, :facebook, :string

  end
end
