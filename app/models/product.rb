class Product < ApplicationRecord
  belongs_to :user
  has_many :list_items, dependent: :nullify

  validates :name, presence: true
  validates :category, presence: true
  validates :default_price, presence: true, numericality: { greater_than: 0 }

  scope :alphabetical, -> { order(Arel.sql("LOWER(name) ASC"), Arel.sql("LOWER(COALESCE(brand, '')) ASC")) }
  scope :search_by_query, lambda { |query|
    next all unless query.present?

    normalized_query = "%#{sanitize_sql_like(query.to_s.downcase)}%"

    where(
      "LOWER(name) LIKE :query OR LOWER(COALESCE(category, '')) LIKE :query",
      query: normalized_query
    )
  }
end
