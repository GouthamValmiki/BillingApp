//
//  CreateBillView.swift
//  BillingApp
//
//  Neumorphic UI Redesign — Bill Creation
//

import SwiftUI
import SwiftData

struct CreateBillView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var customer: Customer
    
    @Query(sort: \Product.productName) private var allProducts: [Product]
    
    @State private var selectedItems: [LineItem] = []
    @State private var selectedProductID: UUID? = nil
    @State private var quantityText = ""
    @State private var amountPaidText = "0"
    @State private var showCategoryFilter = false
    @State private var selectedCategory: String = "All"
    
    private var filteredProducts: [Product] {
        if selectedCategory == "All" {
            return allProducts
        }
        return allProducts.filter { $0.category == selectedCategory }
    }
    
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
            lines.append("  Qty: \(String(format: "%.2f", item.quantity)) \(item.product.unit) x ₹\(String(format: "%.2f", item.product.pricePerUnit))/\(item.product.unit)")
            lines.append("  Subtotal: ₹\(String(format: "%.2f", item.lineTotal))")
        }
        lines.append("---------------------------")
        lines.append("Bill Total: ₹\(String(format: "%.2f", billTotal))")
        let paid = Double(amountPaidText) ?? 0
        lines.append("Paid Now: ₹\(String(format: "%.2f", paid))")
        lines.append("Credit Due: ₹\(String(format: "%.2f", creditAdded))")
        return lines.joined(separator: "\n")
    }

    var body: some View {
        ZStack {
            NeuTheme.baseColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                billHeader
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Product selection
                        productSelectionSection
                        
                        // Category filter
                        categoryFilter
                        
                        // Quick product grid
                        productGrid
                        
                        // Selected items
                        if !selectedItems.isEmpty {
                            selectedItemsSection
                        }
                        
                        // Bill summary
                        if !selectedItems.isEmpty {
                            billSummarySection
                        }
                        
                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, NeuTheme.padding)
                    .padding(.top, 12)
                }
                
                // Bottom action bar
                if !selectedItems.isEmpty {
                    bottomBar
                }
            }
        }
        .navigationTitle("")
    }
    
    // MARK: - Header
    
    private var billHeader: some View {
        HStack(spacing: 12) {
            NeuCircleIcon(systemName: "cart.fill.badge.plus", size: 40, iconSize: 17, accentColor: NeuTheme.greenAccent)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Generate Bill")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text("for \(customer.name)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Item count badge
            if !selectedItems.isEmpty {
                ZStack {
                    Circle()
                        .fill(NeuTheme.greenAccent)
                        .frame(width: 32, height: 32)
                    
                    Text("\(selectedItems.count)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, NeuTheme.padding)
        .padding(.vertical, 10)
        .background(NeuTheme.baseColor)
        .shadow(color: NeuTheme.shadowDark.opacity(0.5), radius: 3, x: 0, y: 3)
    }
    
    // MARK: - Product Selection
    
    private var productSelectionSection: some View {
        NeuCard(padding: 14) {
            NeuSectionHeader(title: "Add Products", icon: "plus.circle.fill")
                .padding(.bottom, 8)
            
            // Product picker
            Menu {
                ForEach(filteredProducts) { prod in
                    Button(action: {
                        selectedProductID = prod.id
                    }) {
                        HStack {
                            Text("\(prod.productName)")
                            Spacer()
                            Text("₹\(String(format: "%.0f", prod.pricePerUnit))/\(prod.unit)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "square.grid.2x2.fill")
                        .foregroundColor(NeuTheme.greenAccent)
                    
                    Text(selectedProductID == nil ? "Select a product" :
                         (allProducts.first(where: { $0.id == selectedProductID })?.productName ?? "Select"))
                        .foregroundColor(selectedProductID == nil ? .secondary : .primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                }
                .font(.system(size: 15, weight: .medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(NeuTheme.baseColor)
                .cornerRadius(NeuTheme.cornerRadiusSmall)
                .shadow(color: NeuTheme.shadowDark, radius: 3, x: -3, y: -3)
                .shadow(color: NeuTheme.shadowLight, radius: 3, x: 3, y: 3)
            }
            
            // Quantity + Add
            HStack(spacing: 12) {
                NeuTextField(placeholder: "Qty", text: $quantityText, icon: "scalemass.fill", keyboardType: .decimalPad)
                
                Button(action: addItem) {
                    ZStack {
                        RoundedRectangle(cornerRadius: NeuTheme.cornerRadiusSmall)
                            .fill(NeuTheme.greenGradient)
                            .frame(width: 48, height: 48)
                            .shadow(color: NeuTheme.greenAccent.opacity(0.3), radius: 4, x: 0, y: 3)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    // MARK: - Category Filter
    
    private var categoryFilter: some View {
        HStack(spacing: 10) {
            categoryPill("All", icon: "square.grid.2x2.fill", color: NeuTheme.greenAccent)
            categoryPill("Seed", icon: "leaf.fill", color: NeuTheme.greenLight)
            categoryPill("Fertilizer", icon: "drop.fill", color: NeuTheme.orangeAccent)
        }
    }
    
    private func categoryPill(_ category: String, icon: String, color: Color) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedCategory = category
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .bold))
                Text(category)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
            }
            .foregroundColor(selectedCategory == category ? .white : color)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(selectedCategory == category ? color : NeuTheme.baseColor)
                    .shadow(color: selectedCategory == category ? color.opacity(0.3) : NeuTheme.shadowLight, radius: selectedCategory == category ? 0 : 3, x: 0, y: selectedCategory == category ? 0 : -2)
                    .shadow(color: selectedCategory == category ? .clear : NeuTheme.shadowDark, radius: selectedCategory == category ? 0 : 3, x: 0, y: selectedCategory == category ? 0 : 2)
            )
        }
    }
    
    // MARK: - Product Grid
    
    private var productGrid: some View {
        VStack(spacing: 10) {
            NeuSectionHeader(title: "Quick Add", icon: "bolt.fill")
                .padding(.bottom, 4)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10)
            ], spacing: 10) {
                ForEach(filteredProducts) { prod in
                    quickProductCard(prod)
                }
            }
        }
    }
    
    private func quickProductCard(_ prod: Product) -> some View {
        Button(action: {
            selectedProductID = prod.id
        }) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: prod.category == "Fertilizer" ? "drop.fill" : "leaf.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(prod.category == "Fertilizer" ? NeuTheme.orangeAccent : NeuTheme.greenAccent)
                    
                    Spacer()
                    
                    if selectedItems.contains(where: { $0.product.id == prod.id }) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(NeuTheme.greenAccent)
                    }
                }
                
                Text(prod.productName)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                HStack {
                    Text("₹\(String(format: "%.0f", prod.pricePerUnit))")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(NeuTheme.greenAccent)
                    Text("/\(prod.unit)")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
            .background(NeuTheme.baseColor)
            .cornerRadius(NeuTheme.cornerRadiusSmall)
            .shadow(color: NeuTheme.shadowLight, radius: 4, x: -3, y: -3)
            .shadow(color: NeuTheme.shadowDark, radius: 4, x: 3, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: NeuTheme.cornerRadiusSmall)
                    .stroke(selectedProductID == prod.id ? NeuTheme.greenAccent : Color.clear, lineWidth: 2)
            )
        }
    }
    
    // MARK: - Selected Items
    
    private var selectedItemsSection: some View {
        NeuCard(padding: 14) {
            NeuSectionHeader(title: "Cart Items", icon: "cart.fill")
                .padding(.bottom, 6)
            
            ForEach(selectedItems) { item in
                HStack(spacing: 12) {
                    // Product icon
                    ZStack {
                        Circle()
                            .fill(NeuTheme.baseColor)
                            .frame(width: 38, height: 38)
                            .shadow(color: NeuTheme.shadowDark, radius: 2, x: -2, y: -2)
                            .shadow(color: NeuTheme.shadowLight, radius: 2, x: 2, y: 2)
                        
                        Image(systemName: item.product.category == "Fertilizer" ? "drop.fill" : "leaf.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(item.product.category == "Fertilizer" ? NeuTheme.orangeAccent : NeuTheme.greenAccent)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.product.productName)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("\(String(format: "%.2f", item.quantity)) \(item.product.unit) × ₹\(String(format: "%.2f", item.product.pricePerUnit))")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("₹\(String(format: "%.2f", item.lineTotal))")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    // Remove button
                    Button(action: {
                        if let idx = selectedItems.firstIndex(where: { $0.id == item.id }) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedItems.remove(at: idx)
                            }
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 6)
                
                if item.id != selectedItems.last?.id {
                    NeuDivider()
                }
            }
        }
    }
    
    // MARK: - Bill Summary
    
    private var billSummarySection: some View {
        NeuCard(padding: 14) {
            NeuSectionHeader(title: "Bill Summary", icon: "receipt.fill")
                .padding(.bottom, 6)
            
            // Bill total
            HStack {
                Text("Bill Total")
                    .font(.system(size: 15, weight: .medium))
                Spacer()
                Text("₹\(String(format: "%.2f", billTotal))")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(NeuTheme.greenAccent)
            }
            
            NeuDivider()
            
            // Amount paid
            VStack(alignment: .leading, spacing: 6) {
                Text("Amount Paid Now")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                
                NeuTextField(placeholder: "0", text: $amountPaidText, icon: "indianrupeesign.circle.fill", keyboardType: .decimalPad)
            }
            
            NeuDivider()
            
            // Credit due
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Credit Added to Customer")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                    Text("Outstanding balance after this bill")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary.opacity(0.7))
                }
                Spacer()
                Text("₹\(String(format: "%.2f", creditAdded))")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundColor(creditAdded > 0 ? NeuTheme.redAccent : NeuTheme.greenAccent)
            }
        }
    }
    
    // MARK: - Bottom Bar
    
    private var bottomBar: some View {
        VStack(spacing: 0) {
            NeuDivider()
            
            HStack(spacing: 12) {
                NeuSoftButton(title: "Cancel", accentColor: .secondary) {
                    dismiss()
                }
                
                NeuButton(title: "Save & Print", icon: "printer.fill") {
                    saveBill()
                }
                .disabled(selectedItems.isEmpty)
            }
            .padding(.horizontal, NeuTheme.padding)
            .padding(.vertical, 12)
            .background(NeuTheme.baseColor)
        }
    }
    
    // MARK: - Actions
    
    private func addItem() {
        guard let id = selectedProductID,
              let product = allProducts.first(where: { $0.id == id }),
              let qty = Double(quantityText), qty > 0 else { return }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedItems.append(LineItem(product: product, quantity: qty))
        }
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

#Preview {
    NavigationStack {
        CreateBillView(customer: Customer(name: "Rajesh Kumar", phone: "9876543210"))
    }
    .modelContainer(for: [Customer.self, Product.self, Transaction.self])
}
