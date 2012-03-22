class AssociateUserToRfp < ActiveRecord::Migration
  def up
  	add_column :rfps,  :user_id, :integer
  end

  def down
  end
end
