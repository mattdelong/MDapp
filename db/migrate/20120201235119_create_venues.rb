class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string 		:company_name
	  t.string 		:address
	  t.string 		:city
	  t.string 		:state
	  t.string 		:zip
	  t.string 		:phone
	  t.string 		:website
	  t.integer 	:user_id
      t.timestamps
    end
  end
end
