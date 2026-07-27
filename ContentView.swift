//
//  ContentView.swift
//  BillingApp
//
//  MVC — View Layer: Customer List (Pure Presentation)
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Customer.name) private var customers: [Customer]
    
    @State private var controller = CustomerController()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                NeuTheme.baseColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerSection
                    
                    // Search bar
                    if controller.showSearch {
                        NeuSearchBar(text: $controller.searchText, placeholder: "Search customers...")
                            .padding(.horizontal, NeuTheme.padding)
                            .padding(.top, 8)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // Customer list
                    let filtered = BillCalculator.filterCustomers(customers: customers, searchText: controller.searchText)
                    if filtered.isEmpty {
                        emptyState
                    } else {
                        customerList(filtered)
                    }
                }
                
                // FAB
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NeuFab(icon: "plus", accentColor: NeuTheme.greenAccent) {
                            controller.showingAddCustomer = true
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .sheet(isPresented: $controller.showingAddCustomer) {
                AddCustomerSheet(controller: controller, context: context)
            }
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack {
                NeuCircleIcon(systemName: "leaf.fill", size: 48, iconSize: 22, accentColor: NeuTheme.greenAccent)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("AgriBill")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(NeuTheme.greenAccent)
                    Text("Fertilizer & Seeds Billing")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: { controller.toggleSearch() }) {
                    ZStack {
                        Circle()
                            .fill(NeuTheme.baseColor)
                            .frame(width: 40, height: 40)
                            .shadow(color: NeuTheme.shadowLight, radius: 4, x: -3, y: -3)
                            .shadow(color: NeuTheme.shadowDark, radius: 4, x: 3, y: 3)
                        
                        Image(systemName: controller.showSearch ? "xmark" : "magnifyingglass")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(NeuTheme.greenAccent)
                    }
                }
            }
            .padding(.horizontal, NeuTheme.padding)
            .padding(.top, 8)
            
            HStack(spacing: 12) {
                statPill(icon: "person.2.fill", value: "\(customers.count)", label: "Customers", color: NeuTheme.greenAccent)
                statPill(icon: "exclamationmark.circle.fill", value: "\(BillCalculator.customersWithCredit(customers: customers))", label: "With Credit", color: NeuTheme.redAccent)
                statPill(icon: "checkmark.circle.fill", value: "\(BillCalculator.settledCustomers(customers: customers))", label: "Settled", color: NeuTheme.blueAccent)
            }
            .padding(.horizontal, NeuTheme.padding)
            .padding(.bottom, 4)
        }
    }
    
    private func statPill(icon: String, value: String, label: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(NeuTheme.baseColor)
                .shadow(color: NeuTheme.shadowLight, radius: 3, x: -2, y: -2)
                .shadow(color: NeuTheme.shadowDark, radius: 3, x: 2, y: 2)
        )
    }
    
    // MARK: - Customer List
    
    private func customerList(_ filtered: [Customer]) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 14) {
                ForEach(filtered) { customer in
                    NavigationLink(destination: CustomerDetailView(customer: customer)) {
                        customerRow(customer: customer)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, NeuTheme.padding)
            .padding(.top, 12)
            .padding(.bottom, 80)
        }
    }
    
    private func customerRow(customer: Customer) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(NeuTheme.baseColor)
                    .frame(width: 50, height: 50)
                    .shadow(color: NeuTheme.shadowLight, radius: 4, x: -3, y: -3)
                    .shadow(color: NeuTheme.shadowDark, radius: 4, x: 3, y: 3)
                
                Text(String(customer.name.prefix(1)).uppercased())
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(NeuTheme.greenAccent)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(customer.name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Text(customer.phone)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("₹\(String(format: "%.2f", customer.totalCredit))")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(customer.totalCredit > 0 ? NeuTheme.redAccent : NeuTheme.greenAccent)
                
                if customer.totalCredit > 0 {
                    NeuBadge(text: "Credit", color: NeuTheme.redAccent)
                } else {
                    NeuBadge(text: "Settled", color: NeuTheme.greenAccent)
                }
            }
        }
        .padding(NeuTheme.padding)
        .background(NeuTheme.baseColor)
        .cornerRadius(NeuTheme.cornerRadius)
        .shadow(color: NeuTheme.shadowLight, radius: NeuTheme.shadowRadius, x: -NeuTheme.shadowOffset, y: -NeuTheme.shadowOffset)
        .shadow(color: NeuTheme.shadowDark, radius: NeuTheme.shadowRadius, x: NeuTheme.shadowOffset, y: NeuTheme.shadowOffset)
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            
            NeuCircleIcon(systemName: "person.crop.circle.badge.plus", size: 80, iconSize: 34, accentColor: NeuTheme.greenAccent)
            
            VStack(spacing: 6) {
                Text("No Customers Yet")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text("Tap the + button to add your first customer")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Customer.self, Product.self, Transaction.self])
}
