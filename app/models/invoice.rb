class Invoice < ApplicationRecord

  validates_presence_of :status
  validates_presence_of :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :discounts, through: :merchants

  enum status: {"in progress" => 0, "completed" => 1, "cancelled" => 2}

  def self.pending_invoices
    where(status: 0)
    .order(:created_at)
  end

  def format_time
    created_at.strftime('%A, %B%e, %Y')
  end

  def total_rev
    invoice_items.sum("quantity * unit_price")
  end

  def total_discount
    invoice_items.joins(:discounts)
      .where('discounts.threshold <= invoice_items.quantity')
      .select('invoice_items.*, max(invoice_items.quantity * invoice_items.unit_price * (discounts.discount)) as total_discount')
      .group("invoice_items.id")
      .sum(&:total_discount)
  end

  def discounted_revenue
    total_rev - total_discount
  end
end
