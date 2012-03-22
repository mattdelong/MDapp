class CreateRfps < ActiveRecord::Migration
  def change
    create_table :rfps do |t|

      t.timestamps
    end
  end
end
