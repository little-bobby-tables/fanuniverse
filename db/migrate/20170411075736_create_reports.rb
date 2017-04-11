class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.integer :reportable_id
      t.string  :reportable_type
      t.integer :reported_by_id
      t.string  :body
      t.integer :resolved_by_id
      t.boolean :resolved, default: false
      t.timestamps
    end
  end
end
