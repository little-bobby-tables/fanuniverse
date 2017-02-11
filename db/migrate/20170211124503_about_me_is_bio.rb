class AboutMeIsBio < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :about_me, :bio
  end
end
