class CreatePlannerProfiles < ActiveRecord::Migration
  def change
    create_table :planner_profiles do |t|
      t.integer :user_id
      t.string :compnay
      t.string :title
      t.text :description
      t.string :linkedin
      t.string :facebook
      t.string :twitter

      t.timestamps
    end
  end
end
