class Article < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 255 }
  validates :text, presence: true

  belongs_to :user
end
