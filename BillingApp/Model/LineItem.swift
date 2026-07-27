//
//  LineItem.swift
//  BillingApp
//
//  MVC — Model Layer: In-memory Line Item for Bill Creation
//

import Foundation

struct LineItem: Identifiable {
    let id = UUID()
    var product: Product
    var quantity: Double
    var lineTotal: Double {
        quantity * product.pricePerUnit
    }
}
