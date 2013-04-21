class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :name
      t.string :description
      t.string :logo
      t.string :twitter
      t.text :address
      t.string :employees
      t.text :founders
      t.boolean :active
      t.boolean :hiring
      t.string :hiringurl
      t.string :listername
      t.string :listeremail

      t.timestamps
    end
  end
end
