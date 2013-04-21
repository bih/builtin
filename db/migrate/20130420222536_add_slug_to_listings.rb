class AddSlugToListings < ActiveRecord::Migration
  def up
  	change_table :listings do |t|
  		t.string :slug
  	end

  	add_index :listings, :slug, unique: true
  end

  def down
  	remove_column :listings, :slug
  	remove_index :listings, :slug
  end
end
