class AddUrlToListings < ActiveRecord::Migration
  def up
  	change_table :listings do |t|
  		t.string :url
  	end
  end

  def down
  	remove_column :listings, :url
  end
end
