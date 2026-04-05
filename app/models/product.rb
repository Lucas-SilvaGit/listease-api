class Product < ApplicationRecord
  belongs_to :user
  has_many :list_items, dependent: :nullify

  validates :name, presence: true
  validates :default_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :alphabetical, -> { order(Arel.sql("LOWER(name) ASC"), Arel.sql("LOWER(COALESCE(brand, '')) ASC")) }
  scope :search_by_name, lambda { |query|
    query.present? ? where("LOWER(name) LIKE ?", "%#{sanitize_sql_like(query.to_s.downcase)}%") : all
  }
end
