require "rails_helper"
require "rspec"

describe "merchants/bulk_discounts index page", type: :feature do
  before (:each) do
    @targay = Merchant.create!(name: "Targay")

    @discount1 = @targay.discounts.create!(discount: 0.10, threshold: 20)
    @discount2 = @targay.discounts.create!(discount: 0.20, threshold: 40)
    @discount3 = @targay.discounts.create!(discount: 0.05, threshold: 10)

    visit "/merchants/#{@targay.id}/discounts"
  end

  describe "when I visit the bulk_discounts index page" do
    it "displays all of my bulk_discounts including their attributes" do
      within('#discounts') do
        expect(page).to have_content("10.0%")
        expect(page).to have_content("20 items")
        expect(page).to have_content("20.0%")
        expect(page).to have_content("40 items")
        expect(page).to have_content("5.0%")
        expect(page).to have_content("10 items")
      end
    end

    it "links me to the discount show page" do
      within("#discounts-#{@discount1.id}") do
        click_on "#{@discount1.to_percent}% off #{@discount1.threshold} items"
      end
      expect(current_path).to eq("/merchants/#{@targay.id}/discounts/#{@discount1.id}")
    end

    it "has a link to create a new discount" do
      click_on "Make a new discount"
      expect(current_path).to eq("/merchants/#{@targay.id}/discounts/new")
    end

    it "creates a new discount" do
      within('#discounts') do
        expect(page).to_not have_content("25.0%")
        expect(page).to_not have_content("50 items")
      end

      click_on "Make a new discount"

      fill_in(:discount, with: "0.25")
      fill_in(:threshold, with: "50")
      click_on "Submit"

      within('#discounts') do
        expect(page).to have_content("25.0%")
        expect(page).to have_content("50 items")
      end
    end

    it "lets me delete a discount" do
      within("#discounts-#{@discount1.id}") do
        click_on "Delete this discount"
      end

      expect(page).to_not have_content("10.0%")
      expect(page).to_not have_content("20 items")
    end
  end

end
