class RedoStars < ActiveRecord::Migration[5.0]
  def change
    create_table :stars do |t|
      t.integer :starrable_id
      t.string  :starrable_type
      t.integer :user_id

      t.index [:starrable_type, :starrable_id]
      t.index [:starrable_type, :starrable_id, :user_id]
    end

    remove_column :images, :stars, :integer
    add_column :images, :star_count, :integer, default: 0
  end
end
