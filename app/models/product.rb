class Product < ApplicationRecord
  belongs_to :brand
  belongs_to :sex
  belongs_to :season
  belongs_to :smell_type
  belongs_to :main_spice
  belongs_to :smell_impression
  belongs_to :use_scene
  has_many :comments
  belongs_to :user
  validates :name, :description, :image, presence: true

  def self.search(search)
    if search
      Product.where('name LIKE ?', "%#{search}%")
    else
      Product.all
    end
  end
end
