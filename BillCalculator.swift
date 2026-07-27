//
//  BillCalculator.swift
//  BillingApp
//
//  MVC — Model Layer: Bill Calculation Business Logic
//

import Foundation

struct BillCalculator {
    
    /// Calculates the total of all line items
    static func calculateTotal(items: [LineItem]) -> Double {
        items.reduce(0) { $0 + $1.lineTotal }
    }
    
    /// Calculates credit added to customer after a bill
    static func calculateCreditAdded(billTotal: Double, amountPaid: Double) -> Double {
        max(0, billTotal - amountPaid)
    }
    
    /// Generates the bill details string for printing/display
    static func generateBillDetails(customer: Customer, items: [LineItem], billTotal: Double, amountPaid: Double, creditAdded: Double) -> String {
        var lines: [String] = []
        lines.append("FERTILIZER & SEED BILL")
        lines.append("Customer: \(customer.name)")
        lines.append("---------------------------")
        for item in items {
            lines.append("\(item.product.productName) (\(item.product.category))")
            lines.append("  Qty: \(String(format: "%.2f", item.quantity)) \(item.product.unit) x ₹\(String(format: "%.2f", item.product.pricePerUnit))/\(item.product.unit)")
            lines.append("  Subtotal: ₹\(String(format: "%.2f", item.lineTotal))")
        }
        lines.append("---------------------------")
        lines.append("Bill Total: ₹\(String(format: "%.2f", billTotal))")
        lines.append("Paid Now: ₹\(String(format: "%.2f", amountPaid))")
        lines.append("Credit Due: ₹\(String(format: "%.2f", creditAdded))")
        return lines.joined(separator: "\n")
    }
    
    /// Filters products by category
    static func filterProducts(products: [Product], category: String) -> [Product] {
        if category == "All" {
            return products
        }
        return products.filter { $0.category == category }
    }
    
    // MARK: - Customer Stats
    
    /// Calculates total billed amount from transactions
    static func totalBilled(transactions: [Transaction]) -> Double {
        transactions.filter { $0.isCreditAddition }.reduce(0.0) { $0 + $1.amount }
    }
    
    /// Calculates total paid amount from transactions
    static func totalPaid(transactions: [Transaction]) -> Double {
        transactions.filter { !$0.isCreditAddition }.reduce(0.0) { $0 + $1.amount }
    }
    
    /// Counts number of bills from transactions
    static func billCount(transactions: [Transaction]) -> Int {
        transactions.filter { $0.isCreditAddition }.count
    }
    
    /// Sorts transactions by date (most recent first)
    static func sortedTransactions(transactions: [Transaction]) -> [Transaction] {
        transactions.sorted(by: { $0.date > $1.date })
    }
    
    /// Counts customers with credit
    static func customersWithCredit(customers: [Customer]) -> Int {
        customers.filter { $0.totalCredit > 0 }.count
    }
    
    /// Counts settled customers
    static func settledCustomers(customers: [Customer]) -> Int {
        customers.filter { $0.totalCredit <= 0 }.count
    }
    
    /// Filters customers by search text
    static func filterCustomers(customers: [Customer], searchText: String) -> [Customer] {
        if searchText.isEmpty {
            return customers
        }
        return customers.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.phone.contains(searchText)
        }
    }
}
