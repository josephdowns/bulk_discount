class Discount < ApplicationRecord
  belongs_to :merchant

  def to_percent
    discount * 100
  end
end
