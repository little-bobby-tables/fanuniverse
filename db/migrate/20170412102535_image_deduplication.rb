class ImageDeduplication < ActiveRecord::Migration[5.0]
  def change
    change_table :images do |t|
      t.text    :phash
      t.integer :merged_into_id
    end
  end
end
