class SingleSource < ActiveRecord::Migration[5.0]
  def change
    remove_column :images, :sources
    add_column :images, :source, :string, null: false, default: ''
  end
end
