//
//  CustomerController.swift
//  BillingApp
//
//  MVC — Controller Layer: Customer Operations
//

import SwiftUI
import SwiftData

@Observable
class CustomerController {
    
    // MARK: - State
    
    var showingAddCustomer = false
    var newName = ""
    var newPhone = ""
    var searchText = ""
    var showSearch = false
    
    // Validation errors
    var nameError: String? = nil
    var phoneError: String? = nil
    
    // MARK: - Computed
    
    /// Is the add-customer form valid?
    var isFormValid: Bool {
        ValidationService.isCustomerFormValid(
            name: newName,
            phone: newPhone,
            nameError: nameError,
            phoneError: phoneError
        )
    }
    
    // MARK: - Validation Actions
    
    func validateName() {
        // Filter input first
        let filtered = ValidationService.filterName(newName)
        if filtered != newName {
            newName = filtered
        }
        nameError = ValidationService.validateName(newName)
    }
    
    func validatePhone() {
        // Filter input first
        let filtered = ValidationService.filterPhone(newPhone)
        if filtered != newPhone {
            newPhone = filtered
        }
        phoneError = ValidationService.validatePhone(newPhone)
    }
    
    // MARK: - CRUD Operations
    
    func addCustomer(context: ModelContext) {
        let customer = Customer(name: newName, phone: newPhone)
        context.insert(customer)
        resetForm()
        showingAddCustomer = false
    }
    
    func deleteCustomer(context: ModelContext, customer: Customer) {
        context.delete(customer)
    }
    
    func deleteCustomers(context: ModelContext, customers: [Customer], offsets: IndexSet) {
        for index in offsets {
            context.delete(customers[index])
        }
    }
    
    func recordPayment(customer: Customer, amount: Double) {
        let transaction = Transaction(
            amount: amount,
            details: "Payment Received",
            isCreditAddition: false
        )
        customer.transactions?.append(transaction)
        customer.totalCredit -= amount
    }
    
    // MARK: - Form Reset
    
    func resetForm() {
        newName = ""
        newPhone = ""
        nameError = nil
        phoneError = nil
    }
    
    func toggleSearch() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showSearch.toggle()
            if !showSearch { searchText = "" }
        }
    }
}
