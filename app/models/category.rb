class Category < ApplicationRecord
  validates :category_tag, presence: true, length: { maximum: 30 }

  belongs_to :user
  has_many :category_articles, dependent: :destroy
  has_many :articles, through: :category_articles
end
