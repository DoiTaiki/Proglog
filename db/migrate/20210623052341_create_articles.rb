class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title, null:false, limit: 100
      t.string :description
      t.text :text, null:false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
