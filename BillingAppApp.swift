//
//  BillingApp.swift
//  BillingApp
//
//  Created by Goutham on 27/07/26.
//

import SwiftUI
import SwiftData

@main
struct BillingAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Customer.self,
            Product.self,
            Transaction.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // Seed default products if empty
            let context = ModelContext(container)
            let descriptor = FetchDescriptor<Product>()
            let count = (try? context.fetch(descriptor).count) ?? 0
            
            if count == 0 {
                let seeds = [
                    Product(productName: "Hybrid Tomato Seed", category: "Seed", unit: "packet", pricePerUnit: 45.0),
                    Product(productName: "Wheat Seed Premium", category: "Seed", unit: "kg", pricePerUnit: 32.0),
                    Product(productName: "Maize Hybrid Seed", category: "Seed", unit: "packet", pricePerUnit: 60.0)
                ]
                
                let fertilizers = [
                    Product(productName: "Urea 46%", category: "Fertilizer", unit: "bag (50kg)", pricePerUnit: 250.0),
                    Product(productName: "DAP Fertilizer", category: "Fertilizer", unit: "bag (50kg)", pricePerUnit: 320.0),
                    Product(productName: "NPK 19:19:19", category: "Fertilizer", unit: "bag (50kg)", pricePerUnit: 280.0),
                    Product(productName: "Organic Compost", category: "Fertilizer", unit: "bag (40kg)", pricePerUnit: 180.0)
                ]
                
                seeds.forEach { context.insert($0) }
                fertilizers.forEach { context.insert($0) }
            }
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
