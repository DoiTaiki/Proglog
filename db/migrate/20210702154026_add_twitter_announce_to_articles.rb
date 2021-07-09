class AddTwitterAnnounceToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :twitter_announce, :boolean, default: false, null: false
  end
end
