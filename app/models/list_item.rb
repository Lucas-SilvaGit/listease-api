class ListItem < ApplicationRecord
  belongs_to :list
  belongs_to :product, optional: true

  validates :name_snapshot, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  before_validation :apply_product_snapshots, on: :create
  before_validation :calculate_total_price

  scope :purchased, -> { where(purchased: true) }
  scope :pending, -> { where(purchased: false) }

  private

  def apply_product_snapshots
    return unless product

    self.name_snapshot = product.name if name_snapshot.blank?
    self.brand_snapshot = product.brand if brand_snapshot.blank?
    self.price = product.default_price if price.blank? && product.default_price.present?
  end

  def calculate_total_price
    self.quantity = quantity.presence || 1
    self.price = price.presence || 0
    self.total_price = quantity.to_d * price.to_d
  end
end
