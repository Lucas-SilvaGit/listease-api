class User < ApplicationRecord
  has_many :lists, dependent: :destroy
  has_many :products, dependent: :destroy
  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :google_uid, uniqueness: true, allow_nil: true
  validates :password, presence: true, if: :password_required?
  validates :password, length: { minimum: 6 }, allow_nil: true

  private

  def password_required?
    google_uid.blank? && password_digest.blank?
  end
end
