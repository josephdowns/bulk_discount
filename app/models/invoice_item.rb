class InvoiceItem < ApplicationRecord

  validates_presence_of :quantity
  validates_presence_of :unit_price
  validates_presence_of :status
  validates_presence_of :item_id
  validates_presence_of :invoice_id

  belongs_to :item
  belongs_to :invoice
  has_one :merchant, through: :item
  has_many :discounts, through: :merchant

  enum status: {pending: 0, packaged: 1, shipped: 2}

  def discount?
    if applied
      return true
    else
      return false
    end
  end

  def applied
    discounts.where("threshold <= ?", self.quantity)
    .order(discount: :desc)
    .limit(1)
    .first
  end
end
