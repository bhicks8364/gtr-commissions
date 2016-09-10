class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :address
      t.string :state
      t.string :zipcode

      t.timestamps null: false
    end
  end
end
