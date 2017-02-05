class CreateStars < ActiveRecord::Migration[5.0]
  def change
    create_table :stars do |t|
      t.integer :resource_id
      t.integer :user_id
      t.timestamps

      t.index :user_id
      t.index [:user_id, :resource_id]
    end

    remove_column :images, :upvotes, :integer
    remove_column :images, :downvotes, :integer

    add_column :images, :stars, :integer, null: false, default: 0
  end
end
