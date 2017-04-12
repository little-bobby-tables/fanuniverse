class ImageDeduplication < ActiveRecord::Migration[5.0]
  def change
    change_table :images do |t|
      t.text    :phash
      t.integer :merged_into_id
    end

    Image.__elasticsearch__.client.indices
      .put_mapping index: Image.index_name,
                   type: Image.document_type,
                   body: Image.mappings.to_hash
  end
end
