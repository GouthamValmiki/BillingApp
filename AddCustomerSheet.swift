//
//  AddCustomerSheet.swift
//  BillingApp
//
//  MVC — View Layer: Add Customer Sheet (Pure Presentation)
//

import SwiftUI
import SwiftData

struct AddCustomerSheet: View {
    @Bindable var controller: CustomerController
    let context: ModelContext
    
    var body: some View {
        ZStack {
            NeuTheme.baseColor.ignoresSafeArea()
            
            NavigationStack {
                VStack(spacing: 20) {
                    // Header illustration
                    NeuCircleIcon(systemName: "person.badge.plus.fill", size: 72, iconSize: 32, accentColor: NeuTheme.greenAccent)
                    
                    Text("New Customer")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(NeuTheme.greenAccent)
                    
                    VStack(spacing: 4) {
                        // Name field
                        NeuTextField(placeholder: "Customer Name", text: $controller.newName, icon: "person.fill", borderColor: controller.nameError != nil ? NeuTheme.redAccent : nil)
                            .onChange(of: controller.newName) { _, _ in
                                controller.validateName()
                            }
                        
                        // Name error message
                        if let nameError = controller.nameError {
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(NeuTheme.redAccent)
                                Text(nameError)
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(NeuTheme.redAccent)
                                Spacer()
                            }
                            .padding(.horizontal, 14)
                            .transition(.move(edge: .leading).combined(with: .opacity))
                        }
                        
                        Spacer().frame(height: 12)
                        
                        // Phone field
                        NeuTextField(placeholder: "Phone Number (10 digits)", text: $controller.newPhone, icon: "phone.fill", keyboardType: .numberPad, borderColor: controller.phoneError != nil ? NeuTheme.redAccent : (controller.newPhone.count == 10 ? NeuTheme.greenAccent : nil))
                            .onChange(of: controller.newPhone) { _, _ in
                                controller.validatePhone()
                            }
                        
                        // Phone error message
                        if let phoneError = controller.phoneError {
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(NeuTheme.redAccent)
                                Text(phoneError)
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(NeuTheme.redAccent)
                                Spacer()
                            }
                            .padding(.horizontal, 14)
                            .transition(.move(edge: .leading).combined(with: .opacity))
                        }
                        
                        // Phone digit counter
                        if !controller.newPhone.isEmpty && controller.phoneError == nil && controller.newPhone.count < 10 {
                            HStack(spacing: 4) {
                                Spacer()
                                Text("\(controller.newPhone.count)/10 digits")
                                    .font(.system(size: 11, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 14)
                        }
                        
                        // Phone success indicator
                        if controller.newPhone.count == 10 && controller.phoneError == nil {
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(NeuTheme.greenAccent)
                                Text("Valid phone number ✓")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(NeuTheme.greenAccent)
                                Spacer()
                            }
                            .padding(.horizontal, 14)
                            .transition(.move(edge: .leading).combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, NeuTheme.padding)
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        NeuButton(title: "Save Customer", icon: "checkmark.circle.fill") {
                            controller.addCustomer(context: context)
                        }
                        .disabled(!controller.isFormValid)
                        .opacity(controller.isFormValid ? 1.0 : 0.4)
                        
                        NeuSoftButton(title: "Cancel", accentColor: .secondary) {
                            controller.resetForm()
                            controller.showingAddCustomer = false
                        }
                    }
                    .padding(.horizontal, NeuTheme.padding)
                    .padding(.bottom, 20)
                }
                .padding(.top, 20)
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: controller.nameError)
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: controller.phoneError)
            }
        }
    }
}
