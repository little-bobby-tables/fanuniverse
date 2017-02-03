class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags, id: false do |t|
      t.string :name
      t.integer :image_count, null: false, default: 0
      t.timestamps
    end
    execute 'ALTER TABLE tags ADD PRIMARY KEY (name);'
  end
end
