class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant

  def to_percent
    discount * 100
  end
end
