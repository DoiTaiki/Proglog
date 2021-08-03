class Article < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 255 }
  validates :text, presence: true

  belongs_to :user
  has_many :category_articles, dependent: :destroy
  has_many :categories, through: :category_articles

  paginates_per 10

  def self.ransackable_attributes(auth_object = nil)
    %w[title updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end
