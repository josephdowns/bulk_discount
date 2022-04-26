require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :invoice_id }
  end

  describe "relationships" do
     it { should belong_to :item }
     it { should belong_to :invoice }
  end

  describe "methods" do
    it "finds discounts" do
      @merchant1 = Merchant.create!(name: "Pabu")

      @discount1 = @merchant1.discounts.create!(discount: 0.1, threshold: 5)
      @discount2 = @merchant1.discounts.create!(discount: 0.5, threshold: 20)

      @item1 = Item.create!(name: "Brush", description: "Brushy", unit_price: 10, merchant_id: @merchant1.id)
      @item2 = Item.create!(name: "Peanut Butter", description: "Yummy", unit_price: 12, merchant_id: @merchant1.id)

      @customer1 = Customer.create!(first_name: "Loki", last_name: "R")

      @invoice1 = @customer1.invoices.create!(status: "completed")

      @ii1 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item1.id, status: 1, quantity: 20, unit_price: 1000)

      expect(@ii1.applied).to eq(@discount2)
    end

    it "returns true if there is a discount" do
      @merchant1 = Merchant.create!(name: "Pabu")

      @discount1 = @merchant1.discounts.create!(discount: 0.1, threshold: 5)
      @discount2 = @merchant1.discounts.create!(discount: 0.4, threshold: 20)

      @item1 = Item.create!(name: "Brush", description: "Brushy", unit_price: 10, merchant_id: @merchant1.id)
      @item2 = Item.create!(name: "Peanut Butter", description: "Yummy", unit_price: 12, merchant_id: @merchant1.id)

      @customer1 = Customer.create!(first_name: "Loki", last_name: "R")

      @invoice1 = @customer1.invoices.create!(status: "completed")

      @ii1 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item1.id, status: 1, quantity: 20, unit_price: 1000)

      expect(@ii1.discount?).to be(true)
    end
    it "returns false if no discount" do
      @merchant1 = Merchant.create!(name: "Pabu")

      @discount1 = @merchant1.discounts.create!(discount: 0.1, threshold: 5)
      @discount2 = @merchant1.discounts.create!(discount: 0.4, threshold: 20)

      @item1 = Item.create!(name: "Brush", description: "Brushy", unit_price: 10, merchant_id: @merchant1.id)
      @item2 = Item.create!(name: "Peanut Butter", description: "Yummy", unit_price: 12, merchant_id: @merchant1.id)

      @customer1 = Customer.create!(first_name: "Loki", last_name: "R")

      @invoice1 = @customer1.invoices.create!(status: "completed")

      @ii1 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item1.id, status: 1, quantity: 4, unit_price: 1000)

      expect(@ii1.discount?).to be(false)
    end
  end
end
