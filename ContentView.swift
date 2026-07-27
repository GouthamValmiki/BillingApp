//
//  ContentView.swift
//  BillingApp
//
//  Created by Goutham on 27/07/26.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Customer.name) private var customers: [Customer]
    
    @State private var showingAddCustomer = false
    @State private var newName = ""
    @State private var newPhone = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(customers) { customer in
                    NavigationLink(destination: CustomerDetailView(customer: customer)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(customer.name).font(.headline)
                                Text(customer.phone).font(.subheadline).foregroundColor(.gray)
                            }
                            Spacer()
                            Text("$\(String(format: "%.2f", customer.totalCredit))")
                                .foregroundColor(customer.totalCredit > 0 ? .red : .green)
                                .bold()
                        }
                    }
                }
                .onDelete(perform: deleteCustomers)
            }
            .navigationTitle("Fertilizer & Seeds Billing")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddCustomer = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCustomer) {
                NavigationView {
                    Form {
                        TextField("Customer Name", text: $newName)
                        TextField("Phone", text: $newPhone).keyboardType(.phonePad)
                    }
                    .navigationTitle("New Customer")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showingAddCustomer = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                let c = Customer(name: newName, phone: newPhone)
                                context.insert(c)
                                newName = ""; newPhone = ""
                                showingAddCustomer = false
                            }
                        }
                    }
                }
            }
        }
    }

    private func deleteCustomers(offsets: IndexSet) {
        for index in offsets {
            context.delete(customers[index])
        }
    }
}
