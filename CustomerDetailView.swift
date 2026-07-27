//
//  CustomerDetailView.swift
//  BillingApp
//
//  Created by Goutham on 27/07/26.
//

import SwiftUI
import SwiftData

struct CustomerDetailView: View {
    @Bindable var customer: Customer
    
    @State private var showingBill = false
    @State private var showingPayment = false
    @State private var paymentAmount = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Card
                VStack(alignment: .leading, spacing: 8) {
                    Text(customer.name).font(.largeTitle).bold()
                    Text(customer.phone).foregroundColor(.gray)
                    Divider()
                    HStack {
                        Text("Credit Balance")
                        Spacer()
                        Text("$\(String(format: "%.2f", customer.totalCredit))")
                            .font(.title).bold()
                            .foregroundColor(customer.totalCredit > 0 ? .red : .primary)
                    }
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Actions
                HStack(spacing: 12) {
                    Button(action: { showingBill = true }) {
                        Label("Generate Bill", systemImage: "cart.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    Button(action: { showingPayment = true }) {
                        Label("Receive Payment", systemImage: "dollarsign.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
                // Ledger
                VStack(alignment: .leading) {
                    Text("Transaction Ledger")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    let sorted = (customer.transactions ?? []).sorted(by: { $0.date > $1.date })
                    
                    if sorted.isEmpty {
                        Text("No transactions yet")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    
                    ForEach(sorted) { t in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(t.details.replacingOccurrences(of: "\n", with: ", "))
                                    .lineLimit(2)
                                    .font(.subheadline).bold()
                                Text(t.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption).foregroundColor(.gray)
                            }
                            Spacer()
                            Text(t.isCreditAddition ? "+ $\(String(format: "%.2f", t.amount))" : "- $\(String(format: "%.2f", t.amount))")
                                .bold()
                                .foregroundColor(t.isCreditAddition ? .red : .green)
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal)
                        Divider()
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle("Customer")
        .sheet(isPresented: $showingBill) {
            CreateBillView(customer: customer)
        }
        .alert("Receive Payment", isPresented: $showingPayment) {
            TextField("Amount ($)", text: $paymentAmount).keyboardType(.decimalPad)
            Button("Cancel", role: .cancel) { paymentAmount = "" }
            Button("Save") {
                if let amt = Double(paymentAmount) {
                    let p = Transaction(amount: amt, details: "Payment Received", isCreditAddition: false)
                    customer.transactions?.append(p)
                    customer.totalCredit -= amt
                    paymentAmount = ""
                }
            }
        }
    }
}
