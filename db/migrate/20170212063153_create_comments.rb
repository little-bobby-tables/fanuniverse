class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string  :body
      t.integer :commentable_id
      t.string  :commentable_type
      t.integer :author_id
      t.timestamps

      t.index [:commentable_type, :commentable_id]
      t.index [:commentable_type, :author_id]
    end
  end
end
