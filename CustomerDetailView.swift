//
//  CustomerDetailView.swift
//  BillingApp
//
//  MVC — View Layer: Customer Detail & Ledger (Pure Presentation)
//

import SwiftUI
import SwiftData

struct CustomerDetailView: View {
    @Bindable var customer: Customer
    
    @State private var showingBill = false
    @State private var showingPayment = false
    @State private var paymentAmount = ""
    @State private var animateBalance = false
    
    var body: some View {
        ZStack {
            NeuTheme.baseColor.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    profileCard
                    actionButtons
                    quickStats
                    transactionLedger
                    Spacer(minLength: 40)
                }
                .padding(.top, 16)
            }
        }
        .navigationTitle("")
        .sheet(isPresented: $showingBill) {
            CreateBillView(customer: customer)
        }
        .alert("Receive Payment", isPresented: $showingPayment) {
            TextField("Amount (₹)", text: $paymentAmount).keyboardType(.decimalPad)
            Button("Cancel", role: .cancel) { paymentAmount = "" }
            Button("Save") {
                if let amt = Double(paymentAmount) {
                    let ctrl = CustomerController()
                    ctrl.recordPayment(customer: customer, amount: amt)
                    paymentAmount = ""
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                animateBalance = true
            }
        }
    }
    
    // MARK: - Profile Card
    
    private var profileCard: some View {
        NeuCard(padding: 20) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(NeuTheme.greenAccent.opacity(0.15))
                        .frame(width: 64, height: 64)
                    
                    Circle()
                        .fill(NeuTheme.baseColor)
                        .frame(width: 56, height: 56)
                        .shadow(color: NeuTheme.shadowLight, radius: 4, x: -3, y: -3)
                        .shadow(color: NeuTheme.shadowDark, radius: 4, x: 3, y: 3)
                    
                    Text(String(customer.name.prefix(1)).uppercased())
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(NeuTheme.greenAccent)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(customer.name)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                        Text(customer.phone)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            
            NeuDivider()
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Credit Balance")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    Text("Outstanding amount")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary.opacity(0.7))
                }
                
                Spacer()
                
                Text("₹\(String(format: "%.2f", customer.totalCredit))")
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundColor(customer.totalCredit > 0 ? NeuTheme.redAccent : NeuTheme.greenAccent)
                    .scaleEffect(animateBalance ? 1.0 : 0.5)
                    .opacity(animateBalance ? 1.0 : 0.0)
            }
        }
        .padding(.horizontal, NeuTheme.padding)
    }
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        HStack(spacing: 12) {
            NeuButton(title: "Bill", icon: "cart.fill", gradient: NeuTheme.greenGradient, fontSize: 15) {
                showingBill = true
            }
            
            NeuButton(title: "Payment", icon: "indianrupeesign.circle.fill", gradient: NeuTheme.blueGradient, shadowColor: NeuTheme.blueAccent, fontSize: 15) {
                showingPayment = true
            }
        }
        .padding(.horizontal, NeuTheme.padding)
    }
    
    // MARK: - Quick Stats
    
    private var quickStats: some View {
        let transactions = customer.transactions ?? []
        let totalBilled = BillCalculator.totalBilled(transactions: transactions)
        let totalPaid = BillCalculator.totalPaid(transactions: transactions)
        let billCount = BillCalculator.billCount(transactions: transactions)
        
        return HStack(spacing: 12) {
            statBlock(icon: "doc.text.fill", value: "₹\(String(format: "%.0f", totalBilled))", label: "Billed", accentColor: NeuTheme.orangeAccent)
            statBlock(icon: "banknote.fill", value: "₹\(String(format: "%.0f", totalPaid))", label: "Paid", accentColor: NeuTheme.greenAccent)
            statBlock(icon: "number.fill", value: "\(billCount)", label: "Bills", accentColor: NeuTheme.blueAccent)
        }
        .padding(.horizontal, NeuTheme.padding)
    }
    
    private func statBlock(icon: String, value: String, label: String, accentColor: Color) -> some View {
        VStack(spacing: 8) {
            NeuCircleIcon(systemName: icon, size: 40, iconSize: 16, accentColor: accentColor)
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .neuRaised(radius: NeuTheme.cornerRadius)
    }
    
    // MARK: - Transaction Ledger
    
    private var transactionLedger: some View {
        let sorted = BillCalculator.sortedTransactions(transactions: customer.transactions ?? [])
        
        return VStack(spacing: 0) {
            NeuSectionHeader(title: "Transaction Ledger", icon: "list.bullet.rectangle.fill")
                .padding(.horizontal, NeuTheme.padding)
                .padding(.bottom, 8)
            
            if sorted.isEmpty {
                VStack(spacing: 12) {
                    NeuCircleIcon(systemName: "tray.fill", size: 56, iconSize: 24, accentColor: .secondary)
                    Text("No transactions yet")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    Text("Generate a bill to see transactions here")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .neuRaised(radius: NeuTheme.cornerRadius)
                .padding(.horizontal, NeuTheme.padding)
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(sorted) { t in
                        transactionRow(t)
                    }
                }
                .padding(.horizontal, NeuTheme.padding)
            }
        }
    }
    
    private func transactionRow(_ t: Transaction) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(NeuTheme.baseColor)
                    .frame(width: 44, height: 44)
                    .shadow(color: NeuTheme.shadowDark, radius: 3, x: -2, y: -2)
                    .shadow(color: NeuTheme.shadowLight, radius: 3, x: 2, y: 2)
                
                Image(systemName: t.isCreditAddition ? "cart.fill" : "indianrupeesign.circle.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(t.isCreditAddition ? NeuTheme.redAccent : NeuTheme.greenAccent)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(t.isCreditAddition ? "Bill Generated" : "Payment Received")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(t.details.replacingOccurrences(of: "\n", with: ", "))
                    .lineLimit(1)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(t.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary.opacity(0.7))
            }
            
            Spacer()
            
            Text(t.isCreditAddition ? "+₹\(String(format: "%.2f", t.amount))" : "-₹\(String(format: "%.2f", t.amount))")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(t.isCreditAddition ? NeuTheme.redAccent : NeuTheme.greenAccent)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(NeuTheme.baseColor)
        .cornerRadius(NeuTheme.cornerRadius)
        .shadow(color: NeuTheme.shadowLight, radius: NeuTheme.shadowRadius, x: -NeuTheme.shadowOffset, y: -NeuTheme.shadowOffset)
        .shadow(color: NeuTheme.shadowDark, radius: NeuTheme.shadowRadius, x: NeuTheme.shadowOffset, y: NeuTheme.shadowOffset)
    }
}

#Preview {
    NavigationStack {
        CustomerDetailView(customer: Customer(name: "Rajesh Kumar", phone: "9876543210"))
    }
    .modelContainer(for: [Customer.self, Transaction.self])
}
