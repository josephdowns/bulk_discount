require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end

  describe "relationships" do
    it { should have_many :invoices }
  end

  describe "methods" do
    describe "full_name" do
      it "displays a full name in one line" do
        joseph = Customer.create!(first_name: "Joseph", last_name: "Downs")

        expect(joseph.full_name).to eq("Joseph Downs")
      end
    end

    describe "succsessful_transaction_count" do
      it "finds succsessful_transaction_count" do
        joseph = Customer.create!(first_name: "Joseph", last_name: "Downs")

        invoice = joseph.invoices.create!(status: "completed")

        transactions1 = invoice.transactions.create!(credit_card_number: 7654321098, result: "success")
        transactions2 = invoice.transactions.create!(credit_card_number: 7654321098, result: "success")
        transactions3 = invoice.transactions.create!(credit_card_number: 7654321098, result: "failed")

        expect(joseph.succsessful_transaction_count).to eq(2)
      end
    end

    describe "top_five_customers" do
      it "finds the top_five_customers" do
        joseph = Customer.create!(first_name: "Joseph", last_name: "Downs")
        reuben = Customer.create!(first_name: "Reuben", last_name: "Downs")
        susan = Customer.create!(first_name: "Susan", last_name: "Downs")
        will = Customer.create!(first_name: "Will", last_name: "Downs")
        heather = Customer.create!(first_name: "Heather", last_name: "Downs")
        luke = Customer.create!(first_name: "Luke", last_name: "Downs")

        invoice1 = joseph.invoices.create!(status: "completed")
        invoice1a = joseph.invoices.create!(status: "completed")
        invoice2 = reuben.invoices.create!(status: "completed")
        invoice3 = susan.invoices.create!(status: "completed")
        invoice4 = will.invoices.create!(status: "completed")
        invoice5 = heather.invoices.create!(status: "completed")
        invoice6 = luke.invoices.create!(status: "completed")

        tr1 = invoice1.transactions.create!(credit_card_number: 12345678, result: "success")
        tr1a = invoice1a.transactions.create!(credit_card_number: 12345678, result: "success")
        tr2 = invoice2.transactions.create!(credit_card_number: 12345678, result: "success")
        tr3 = invoice3.transactions.create!(credit_card_number: 12345678, result: "failed")
        tr4 = invoice4.transactions.create!(credit_card_number: 12345678, result: "success")
        tr5 = invoice5.transactions.create!(credit_card_number: 12345678, result: "success")
        tr6 = invoice6.transactions.create!(credit_card_number: 12345678, result: "success")

        expect(Customer.top_five_customers).to eq([joseph, reuben, will, heather, luke])

      end
    end
  end
end
