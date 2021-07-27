class DropTableTwitterUsers < ActiveRecord::Migration[6.1]
  def change
    drop_table :twitter_users do |t|
      t.string "uid", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end
  end
end
