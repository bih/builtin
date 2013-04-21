class AddFeatured < ActiveRecord::Migration
  def up
  	change_table :listings do |t|
  		t.boolean :featured
  	end

  end

  def down
  	remove_column :listings, :featured
  end
end
