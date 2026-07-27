//
//  CreateBillView.swift
//  BillingApp
//
//  Created by Goutham on 27/07/26.
//

import SwiftUI
import SwiftData

// Helper for line items in memory
struct LineItem {
    var product: Product
    var quantity: Double
    var lineTotal: Double {
        quantity * product.pricePerUnit
    }
}

struct CreateBillView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var customer: Customer
    
    @Query(sort: \Product.productName) private var allProducts: [Product]
    
    @State private var selectedItems: [LineItem] = []
    @State private var selectedProductID: UUID? = nil
    @State private var quantityText = ""
    @State private var amountPaidText = "0"
    
    private var billTotal: Double {
        selectedItems.reduce(0) { $0 + $1.lineTotal }
    }
    
    private var creditAdded: Double {
        let paid = Double(amountPaidText) ?? 0
        return max(0, billTotal - paid)
    }
    
    private var billDetailsString: String {
        var lines: [String] = []
        lines.append("FERTILIZER & SEED BILL")
        lines.append("Customer: \(customer.name)")
        lines.append("---------------------------")
        for item in selectedItems {
            lines.append("\(item.product.productName) (\(item.product.category))")
            lines.append("  Qty: \(String(format: "%.2f", item.quantity)) \(item.product.unit) x $\(String(format: "%.2f", item.product.pricePerUnit))/\(item.product.unit)")
            lines.append("  Subtotal: $\(String(format: "%.2f", item.lineTotal))")
        }
        lines.append("---------------------------")
        lines.append("Bill Total: $\(String(format: "%.2f", billTotal))")
        let paid = Double(amountPaidText) ?? 0
        lines.append("Paid Now: $\(String(format: "%.2f", paid))")
        lines.append("Credit Due: $\(String(format: "%.2f", creditAdded))")
        return lines.joined(separator: "\n")
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add Products").font(.headline)) {
                    Picker("Select Product", selection: $selectedProductID) {
                        Text("Choose a product").tag(nil as UUID?)
                        ForEach(allProducts) { prod in
                            Text("\(prod.productName) - $\(String(format: "%.0f", prod.pricePerUnit))/\(prod.unit) (\(prod.category))")
                                .tag(prod.id as UUID?)
                        }
                    }
                    
                    HStack {
                        TextField("Quantity", text: $quantityText)
                            .keyboardType(.decimalPad)
                        Button("Add") {
                            addItem()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                
                if !selectedItems.isEmpty {
                    Section(header: Text("Selected Items").font(.headline)) {
                        ForEach(selectedItems.indices, id: \.self) { index in
                            let item = selectedItems[index]
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.product.productName).bold()
                                    Text("\(String(format: "%.2f", item.quantity)) \(item.product.unit) @ $\(String(format: "%.2f", item.product.pricePerUnit))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text("$\(String(format: "%.2f", item.lineTotal))")
                                    .bold()
                                Button(role: .destructive) {
                                    selectedItems.remove(at: index)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                }
                
                Section {
                    HStack {
                        Text("Bill Total:")
                        Spacer()
                        Text("$\(String(format: "%.2f", billTotal))").bold()
                    }
                    
                    TextField("Amount Paid Now ($)", text: $amountPaidText)
                        .keyboardType(.decimalPad)
                    
                    HStack {
                        Text("Credit Added to Customer:")
                        Spacer()
                        Text("$\(String(format: "%.2f", creditAdded))")
                            .bold()
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Generate Bill")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save & Print") {
                        saveBill()
                    }
                    .disabled(selectedItems.isEmpty)
                }
            }
        }
    }
    
    private func addItem() {
        guard let id = selectedProductID,
              let product = allProducts.first(where: { $0.id == id }),
              let qty = Double(quantityText), qty > 0 else { return }
        
        selectedItems.append(LineItem(product: product, quantity: qty))
        quantityText = ""
        selectedProductID = nil
    }
    
    private func saveBill() {
        guard !selectedItems.isEmpty else { return }
        
        let total = billTotal
        let paid = Double(amountPaidText) ?? 0.0
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
        
//        dismiss()
    }
}
