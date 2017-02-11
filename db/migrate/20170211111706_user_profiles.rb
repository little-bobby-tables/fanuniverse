class UserProfiles < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :about_me
    end
  end
end
