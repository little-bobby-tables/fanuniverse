class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.integer :user_id

      t.string :bio, default: '', null: false
      t.integer :comment_count, default: 0

      t.column :updated_at, :datetime
    end

    #remove_column :users, :bio
  end
end
