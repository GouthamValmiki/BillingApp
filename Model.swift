//
//  Model.swift
//  BillingApp
//
//  Created by Goutham on 27/07/26.
//

import Foundation
import SwiftData

@Model
class Customer {
    var id: UUID
    var name: String
    var phone: String
    var totalCredit: Double
    
    @Relationship(deleteRule: .cascade, inverse: \Transaction.customer)
    var transactions: [Transaction]?
    
    init(name: String, phone: String, totalCredit: Double = 0.0) {
        self.id = UUID()
        self.name = name
        self.phone = phone
        self.totalCredit = totalCredit
    }
}

@Model
class Product {
    var id: UUID
    var productName: String
    var category: String // "Fertilizer" or "Seed"
    var unit: String      // "kg", "bag", "packet"
    var pricePerUnit: Double
    
    init(productName: String, category: String, unit: String, pricePerUnit: Double) {
        self.id = UUID()
        self.productName = productName
        self.category = category
        self.unit = unit
        self.pricePerUnit = pricePerUnit
    }
}

@Model
class Transaction {
    var id: UUID
    var date: Date
    var amount: Double // Total bill amount
    var details: String // Bill summary / line items
    var isCreditAddition: Bool // true = unpaid bill added to credit, false = payment
    
    var customer: Customer?
    
    init(amount: Double, details: String, isCreditAddition: Bool) {
        self.id = UUID()
        self.date = Date()
        self.amount = amount
        self.details = details
        self.isCreditAddition = isCreditAddition
    }
}
