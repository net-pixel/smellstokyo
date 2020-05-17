class Address < ApplicationRecord
  belongs_to :user
  has_one :order, dependent: :nullify

  VALID_NAME_REGEX = /\A[一-龥ぁ-ん]/
  VALID_KANA_REGEX = /\A[ぁ-んー－]+\z/
  VALID_PHONE_REGEX = /\A\d{10,11}\z/
  validates :prefecture_code, :address_city, :address_street, presence: true
  validates :destination_first_name, :destination_family_name, format: { with: VALID_NAME_REGEX }, presence: true
  validates :destination_first_name_kana, :destination_family_name_kana, format: { with: VALID_KANA_REGEX }, presence: true
  validates :postcode, presence: true, numericality: { only_integer: true }

  def postcode=(value)
    value.tr!('０-９', '0-9') if value.is_a?(String)
    super(value)
  end
end
