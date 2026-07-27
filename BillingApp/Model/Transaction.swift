//
//  Transaction.swift
//  BillingApp
//
//  MVC — Model: Transaction Entity
//

import Foundation
import SwiftData

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
