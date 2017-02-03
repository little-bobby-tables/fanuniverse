class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.integer :upvotes
      t.integer :downvotes

      t.string :tag_names, default: [],   null: false, array: true
      t.string :sources,   default: [''], null: false, array: true

      t.timestamps

      t.index :tag_names, using: :gin
    end
  end
end
