class CreatePlannerUsers < ActiveRecord::Migration
  def change
    create_table :planner_users do |t|

      t.timestamps
    end
  end
end
