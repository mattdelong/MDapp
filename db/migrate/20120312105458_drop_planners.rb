class DropPlanners < ActiveRecord::Migration
  def up
  	drop_table  :planners
  end

  def down
  end
end
