class PersistImageMetadata < ActiveRecord::Migration[5.0]
  def change
    change_table :images do |t|
      t.integer :width
      t.integer :height
      t.boolean :processed, default: false
    end
  end
end
