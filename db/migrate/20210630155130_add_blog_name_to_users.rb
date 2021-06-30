class AddBlogNameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :blog_name, :string, null: false, limit: 30
  end
end
