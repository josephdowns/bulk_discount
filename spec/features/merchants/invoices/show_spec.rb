require 'rails_helper'

RSpec.describe 'merchant dashboard' do
  before :each do
    @merchant1 = Merchant.create!(name: "Pabu")
    @merchant2 = Merchant.create!(name: "Ian")

    @discount1 = @merchant1.discounts.create!(discount: 0.1, threshold: 5)
    @discount2 = @merchant1.discounts.create!(discount: 0.5, threshold: 20)

    @item1 = Item.create!(name: "Brush", description: "Brushy", unit_price: 10, merchant_id: @merchant1.id)
    @item2 = Item.create!(name: "Peanut Butter", description: "Yummy", unit_price: 12, merchant_id: @merchant1.id)
    @item3 = Item.create!(name: "Zenitsu Pop Funko", description: "Coolest thing ever", unit_price: 120, merchant_id: @merchant2.id)

    @customer1 = Customer.create!(first_name: "Loki", last_name: "R")
    @customer2 = Customer.create!(first_name: "Thor", last_name: "R")
    @customer3 = Customer.create!(first_name: "Monkey", last_name: "Luffy")

    @invoice1 = @customer1.invoices.create!(status: "completed")
    @invoice2 = @customer2.invoices.create!(status: "completed")
    @invoice3 = @customer3.invoices.create!(status: "completed")

    @ii1 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item1.id, status: 1, quantity: 20, unit_price: 1000)
    @ii2 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item2.id, status: 1, quantity: 5, unit_price: 1200)
    @ii3 = InvoiceItem.create!(invoice_id: @invoice2.id, item_id: @item1.id, status: 1, quantity: 30, unit_price: 1000)
    @ii4 = InvoiceItem.create!(invoice_id: @invoice3.id, item_id: @item3.id, status: 2, quantity: 3, unit_price: 1100)

    visit merchant_invoice_path(@merchant1, @invoice1)
  end

  it 'has header' do
    expect(page).to have_content("Invoice #{@invoice1.id}")
  end

  it 'shows all invoice attributes' do
    within("#invoice") do
      expect(page).to have_content(@invoice1.id)
      expect(page).to have_content(@invoice1.status)
      expect(page).to have_content(@invoice1.created_at.strftime("%A, %b %d, %Y"))
      expect(page).to have_content(@customer1.first_name)
      expect(page).to have_content(@customer1.last_name)
    end
  end
  it 'has item header' do
    expect(page).to have_content("Invoice Items")
  end

  it 'shows all item attributes' do
    within("#invoice-item-#{@item1.id}-#{@ii1.id}") do
      expect(page).to have_content(@item1.name)
      expect(page).to have_content("Quantity:")
      expect(page).to have_content(@ii1.quantity)
      expect(page).to have_content("Price:")
      expect(page).to have_content(@item1.unit_price)
      expect(page).to have_content("Invoice item status:")
      expect(page).to have_content(@ii1.status)
    end
  end

  it 'does not have items from other merchants' do
    within("#invoice-item-#{@item1.id}-#{@ii1.id}") do
      expect(page).to_not have_content(@item3.name)
      expect(page).to_not have_content(@ii4.quantity)
      expect(page).to_not have_content(@item3.unit_price)
    end
  end

  it 'does not have items from other merchants' do
    within("#invoice-item-#{@item1.id}-#{@ii1.id}") do
      select "shipped", from: "Change status"
      click_button "Update Item Status"

      expect(current_path).to eq(merchant_invoice_path(@merchant1, @invoice1))
    end
  end

  it 'shows total revenue generated' do
    expect(page).to have_content("Total revenue generated:")
    within("#invoice") do
      expect(page).to have_content("$260.00")
    end
  end

  it "shows discount revenue generated" do
    within("#invoice") do
      expect(page).to have_content("Discounted Total Revenue:")
      expect(page).to have_content("$154.00")
    end
  end

  it "displays when a discount will be applied" do
    within("#invoice-item-#{@item1.id}-#{@ii1.id}") do
      expect(page).to have_content("Discount: Applied")
      click_on "Applied"
    end
    expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount2.id}")
  end

  it "displays when a discount will not be applied" do
    visit "/merchants/#{@merchant2.id}/invoices/#{@invoice3.id}"

    within("#invoice-item-#{@item3.id}-#{@ii4.id}") do
      expect(page).to have_content("Discount: No discount found")
    end
  end

end
