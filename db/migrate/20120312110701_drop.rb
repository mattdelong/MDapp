class Drop < ActiveRecord::Migration
  def up
  	drop_table  :planner_users
  end

  def down
  end
end
