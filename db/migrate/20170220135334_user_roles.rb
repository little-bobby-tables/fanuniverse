class UserRoles < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :role
    end

    execute 'CREATE UNIQUE INDEX index_users_on_lowercase_name ON users USING btree (lower(name));'
  end
end
