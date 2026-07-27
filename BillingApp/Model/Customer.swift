//
//  Customer.swift
//  BillingApp
//
//  MVC — Model: Customer Entity
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
