class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :name
      t.string   :email
      t.integer  :uuid
      t.boolean  :gender
      t.text     :biography
      t.datetime :birth_date
      t.timestamps
    end
  end
end