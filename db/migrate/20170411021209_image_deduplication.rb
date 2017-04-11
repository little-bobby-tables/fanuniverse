class ImageDeduplication < ActiveRecord::Migration[5.0]
  def change
    change_table :images do |t|
      t.text :phash
    end
  end
end
