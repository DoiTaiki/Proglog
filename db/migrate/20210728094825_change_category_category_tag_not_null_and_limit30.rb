class ChangeCategoryCategoryTagNotNullAndLimit30 < ActiveRecord::Migration[6.1]
  def up
    change_column :categories, :category_tag, :string, limit: 30, null: false
  end

  def down
    change_column :categories, :category_tag, :string
  end
end
