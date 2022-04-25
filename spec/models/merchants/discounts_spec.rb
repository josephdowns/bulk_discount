require "rails_helper"
require "rspec"

describe Discount, type: :model do
  describe "methods" do
    it "changes to_percent" do
      targay = Merchant.create!(name: "Targay")
      discount = targay.discounts.create!(discount: 0.10, threshold: 10)

      expect(discount.to_percent).to eq(10.0)
    end
  end
end
