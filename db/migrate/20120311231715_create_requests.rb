class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer  :rfp_id
      t.integer  :venue_id
      t.boolean  :unread, :default => true
      t.timestamps
    end
  end
end
