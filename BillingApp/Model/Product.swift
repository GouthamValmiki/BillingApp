//
//  Product.swift
//  BillingApp
//
//  MVC — Model: Product Entity
//

import Foundation
import SwiftData

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
