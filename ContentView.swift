//
//  ContentView.swift
//  BillingApp
//
//  Neumorphic UI Redesign — Customer List
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Customer.name) private var customers: [Customer]
    
    @State private var showingAddCustomer = false
    @State private var newName = ""
    @State private var newPhone = ""
    @State private var searchText = ""
    @State private var showSearch = false
    
    private var filteredCustomers: [Customer] {
        if searchText.isEmpty {
            return customers
        }
        return customers.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.phone.contains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                NeuTheme.baseColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerSection
                    
                    // Search bar
                    if showSearch {
                        NeuSearchBar(text: $searchText, placeholder: "Search customers...")
                            .padding(.horizontal, NeuTheme.padding)
                            .padding(.top, 8)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // Customer list
                    if filteredCustomers.isEmpty {
                        emptyState
                    } else {
                        customerList
                    }
                }
                
                // FAB
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NeuFab(icon: "plus", accentColor: NeuTheme.greenAccent) {
                            showingAddCustomer = true
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .sheet(isPresented: $showingAddCustomer) {
                addCustomerSheet
            }
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack {
                // App icon
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
                
                // Search toggle
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        showSearch.toggle()
                        if !showSearch { searchText = "" }
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(NeuTheme.baseColor)
                            .frame(width: 40, height: 40)
                            .shadow(color: NeuTheme.shadowLight, radius: 4, x: -3, y: -3)
                            .shadow(color: NeuTheme.shadowDark, radius: 4, x: 3, y: 3)
                        
                        Image(systemName: showSearch ? "xmark" : "magnifyingglass")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(NeuTheme.greenAccent)
                    }
                }
            }
            .padding(.horizontal, NeuTheme.padding)
            .padding(.top, 8)
            
            // Stats bar
            HStack(spacing: 12) {
                statPill(icon: "person.2.fill", value: "\(customers.count)", label: "Customers", color: NeuTheme.greenAccent)
                statPill(icon: "exclamationmark.circle.fill", value: "\(customers.filter { $0.totalCredit > 0 }.count)", label: "With Credit", color: NeuTheme.redAccent)
                statPill(icon: "checkmark.circle.fill", value: "\(customers.filter { $0.totalCredit <= 0 }.count)", label: "Settled", color: NeuTheme.blueAccent)
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
    
    private var customerList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 14) {
                ForEach(filteredCustomers) { customer in
                    NavigationLink(destination: CustomerDetailView(customer: customer)) {
                        customerRow(customer: customer)
                    }
                    .buttonStyle(.plain)
                }
                .onDelete(perform: deleteCustomers)
            }
            .padding(.horizontal, NeuTheme.padding)
            .padding(.top, 12)
            .padding(.bottom, 80) // Space for FAB
        }
    }
    
    private func customerRow(customer: Customer) -> some View {
        HStack(spacing: 14) {
            // Avatar circle
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
            
            // Info
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
            
            // Credit amount
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
    
    // MARK: - Add Customer Sheet
    
    private var addCustomerSheet: some View {
        ZStack {
            NeuTheme.baseColor.ignoresSafeArea()
            
            NavigationStack {
                VStack(spacing: 20) {
                    // Header illustration
                    NeuCircleIcon(systemName: "person.badge.plus.fill", size: 72, iconSize: 32, accentColor: NeuTheme.greenAccent)
                    
                    Text("New Customer")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(NeuTheme.greenAccent)
                    
                    VStack(spacing: 16) {
                        NeuTextField(placeholder: "Customer Name", text: $newName, icon: "person.fill")
                        NeuTextField(placeholder: "Phone Number", text: $newPhone, icon: "phone.fill", keyboardType: .phonePad)
                    }
                    .padding(.horizontal, NeuTheme.padding)
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        NeuButton(title: "Save Customer", icon: "checkmark.circle.fill") {
                            let c = Customer(name: newName, phone: newPhone)
                            context.insert(c)
                            newName = ""; newPhone = ""
                            showingAddCustomer = false
                        }
                        .disabled(newName.isEmpty || newPhone.isEmpty)
                        .opacity(newName.isEmpty || newPhone.isEmpty ? 0.5 : 1.0)
                        
                        NeuSoftButton(title: "Cancel", accentColor: .secondary) {
                            showingAddCustomer = false
                            newName = ""; newPhone = ""
                        }
                    }
                    .padding(.horizontal, NeuTheme.padding)
                    .padding(.bottom, 20)
                }
                .padding(.top, 20)
            }
        }
    }
    
    // MARK: - Actions
    
    private func deleteCustomers(offsets: IndexSet) {
        for index in offsets {
            context.delete(filteredCustomers[index])
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Customer.self, Product.self, Transaction.self])
}
