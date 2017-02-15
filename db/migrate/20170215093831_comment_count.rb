class CommentCount < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :comment_count, :integer, default: 0
  end
end
