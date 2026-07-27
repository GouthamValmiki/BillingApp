//
//  BillController.swift
//  BillingApp
//
//  MVC — Controller Layer: Bill Creation & Management
//

import SwiftUI
import SwiftData

@Observable
class BillController {
    
    // MARK: - State
    
    var selectedItems: [LineItem] = []
    var selectedProductID: UUID? = nil
    var quantityText = ""
    var amountPaidText = "0"
    var selectedCategory: String = "All"
    
    // MARK: - Computed
    
    var billTotal: Double {
        BillCalculator.calculateTotal(items: selectedItems)
    }
    
    var amountPaid: Double {
        Double(amountPaidText) ?? 0
    }
    
    var creditAdded: Double {
        BillCalculator.calculateCreditAdded(billTotal: billTotal, amountPaid: amountPaid)
    }
    
    var billDetailsString: String {
        BillCalculator.generateBillDetails(
            customer: customer,
            items: selectedItems,
            billTotal: billTotal,
            amountPaid: amountPaid,
            creditAdded: creditAdded
        )
    }
    
    var filteredProducts: [Product] {
        BillCalculator.filterProducts(products: allProducts, category: selectedCategory)
    }
    
    var isCartEmpty: Bool {
        selectedItems.isEmpty
    }
    
    // MARK: - Dependencies
    
    var customer: Customer
    var allProducts: [Product]
    
    init(customer: Customer, allProducts: [Product]) {
        self.customer = customer
        self.allProducts = allProducts
    }
    
    // MARK: - Actions
    
    func addItem() {
        guard let id = selectedProductID,
              let product = allProducts.first(where: { $0.id == id }),
              let qty = Double(quantityText), qty > 0 else { return }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedItems.append(LineItem(product: product, quantity: qty))
        }
        quantityText = ""
        selectedProductID = nil
    }
    
    func removeItem(at index: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedItems.remove(at: index)
        }
    }
    
    func removeItem(id: UUID) {
        if let idx = selectedItems.firstIndex(where: { $0.id == id }) {
            removeItem(at: idx)
        }
    }
    
    func selectCategory(_ category: String) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedCategory = category
        }
    }
    
    func isProductInCart(productID: UUID) -> Bool {
        selectedItems.contains(where: { $0.product.id == productID })
    }
    
    func selectedProductName() -> String {
        if selectedProductID == nil {
            return "Select a product"
        }
        return allProducts.first(where: { $0.id == selectedProductID })?.productName ?? "Select"
    }
    
    // MARK: - Save & Print
    
    func saveBill(dismiss: DismissAction) {
        guard !selectedItems.isEmpty else { return }
        
        let total = billTotal
        let paid = amountPaid
        let netCreditChange = total - paid
        
        // 1. Save the bill transaction
        let billTx = Transaction(
            amount: total,
            details: billDetailsString,
            isCreditAddition: true
        )
        customer.transactions = (customer.transactions ?? []) + [billTx]
        
        // 2. Save the payment transaction if any cash was paid now
        if paid > 0 {
            let payTx = Transaction(
                amount: paid,
                details: "Payment received against bill",
                isCreditAddition: false
            )
            customer.transactions = (customer.transactions ?? []) + [payTx]
        }
        
        // 3. Update customer credit balance
        customer.totalCredit += netCreditChange
        
        // 4. Print the bill
        PrintManager.shared.printBill(
            customerName: customer.name,
            amount: total,
            details: billDetailsString
        )
        
        dismiss()
    }
}
