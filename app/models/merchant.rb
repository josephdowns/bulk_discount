class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices, through: :items
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  enum status: {disabled: 0, enabled: 1}

  def most_popular_items
    items.joins(invoices: :transactions)
      .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
      .where('transactions.result = ?', 'success')
      .group('items.id')
      .order('total_revenue desc')
      .limit(5)
  end


  def unshipped_invoice_items
    items.select('items.name, invoice_items.invoice_id, invoice_items.status, invoice_items.id AS invoice_item_id, invoices.created_at AS invoice_created_at')
    .where("invoice_items.status = 0 OR invoice_items.status = 1")
    .joins(:invoices)
    .order('invoices.created_at')
  end
end
