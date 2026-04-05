class List < ApplicationRecord
  KINDS = %w[monthly free].freeze

  belongs_to :user
  has_many :list_items, dependent: :destroy

  validates :name, presence: true
  validates :kind, presence: true, inclusion: { in: KINDS }
  validates :month, inclusion: { in: 1..12 }, allow_nil: true
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 2000 }, allow_nil: true
  validate :monthly_lists_require_month_and_year

  scope :recent_first, -> { order(updated_at: :desc, created_at: :desc) }

  def total_amount
    list_items.sum(:total_price)
  end

  def items_count
    list_items.count
  end

  def purchased_count
    list_items.purchased.count
  end

  private

  def monthly_lists_require_month_and_year
    return unless kind == "monthly"

    errors.add(:month, "is required for monthly lists") if month.blank?
    errors.add(:year, "is required for monthly lists") if year.blank?
  end
end

