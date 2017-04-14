class ImageDeduplication < ActiveRecord::Migration[5.0]
  def up
    change_table :images do |t|
      t.text    :phash
      t.integer :merged_into_id
    end

    Image.__elasticsearch__.client.indices
      .put_mapping index: Image.index_name,
                   type: Image.document_type,
                   body: Image.mappings.to_hash

    Image.import force: true

    Image.select(:id, :image).find_each do |image|
      phashion = Phashion::Image.new image.image.file.path
      image.update_columns phash: phashion.fingerprint.to_s(2)
    end
  end
end
