require "rails_helper"
require "rspec"

describe "the merchant/discounts show page" do
  before (:each) do
    @targay = Merchant.create!(name: "Targay")

    @discount1 = @targay.discounts.create!(discount: 0.10, threshold: 10)
    @discount2 = @targay.discounts.create!(discount: 0.25, threshold: 30)
  end
  describe "when I visit the merchant/discounts show page" do
    it "displays the discount" do
      visit "/merchants/#{@targay.id}/discounts/#{@discount1.id}"

      expect(page).to have_content("10.0%")
      expect(page).to_not have_content("25.0%")
      expect(page).to have_content("10 items")
      expect(page).to_not have_content("30 items")
    end

    it "allows me to edit the discounts" do
      visit "/merchants/#{@targay.id}/discounts/#{@discount1.id}"

      expect(page).to_not have_content("65.0%")
      expect(page).to_not have_content("100 items")

      click_on "Edit this discount"

      fill_in(:discount, with: 0.65)
      fill_in(:threshold, with: 100)
      click_on "Submit"

      expect(page).to have_content("65.0%")
      expect(page).to have_content("100 items")
      expect(page).to_not have_content("10.0%")
      expect(page).to_not have_content("10 items")
    end
  end
end
