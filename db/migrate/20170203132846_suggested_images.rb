class SuggestedImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :suggested_by_id, :integer
    add_foreign_key :images, :users, column: :suggested_by_id
  end
end
