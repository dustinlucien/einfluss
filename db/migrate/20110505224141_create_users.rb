class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :twitter
      t.string :github
      t.string :stackoverflow
      t.string :company
      t.string :location
      t.datetime :joined
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
