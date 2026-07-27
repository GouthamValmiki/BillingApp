<div align="center">

# 🌱 AgriBill

**Smart billing & invoicing for fertilizer & seed shops**

*A real-world iOS business app — not just a demo*

</div>

---

## 📋 Overview

AgriBill is a production-grade iOS application that replaces manual billing workflows for agricultural shops. Shop owners can manage customers, generate styled invoices, track credit balances, record payments, and maintain complete billing history — all from their iPhone.

## ✨ Features

| Category | Features |
|----------|----------|
| 👤 **Customer Management** | Add, search, view, and manage customer records |
| 🧾 **Invoice Generation** | Create bills with product selection, quantity, and automatic totals |
| 💰 **Credit & Payments** | Track outstanding balances, record payments, view credit history |
| 📊 **Dashboard** | Customer summary with total billed, total paid, and balance |
| 📱 **Neumorphic UI** | 15+ reusable soft-UI components for a modern, tactile feel |
| ✅ **Field Validation** | Real-time input filtering — name rejects numbers/symbols, phone accepts exactly 10 digits |
| 📄 **PDF Export** | Styled HTML invoice template with professional formatting |
| 💾 **Local Storage** | SwiftData persistence with automatic model migration |

## 🛠 Tech Stack

- **Language:** Swift 5
- **UI Framework:** SwiftUI (Neumorphic / Soft UI design)
- **Architecture:** MVC (Model-View-Controller) with `@Observable` controllers
- **Persistence:** SwiftData (`@Model` entities)
- **PDF Generation:** UIGraphicsPDFRenderer + styled HTML templates
- **Validation:** Custom `ValidationService` with real-time input filtering
- **Tools:** Xcode, Git, GitHub

## 📐 Project Structure

```
BillingApp/
├── Model/
│   ├── Customer.swift          # SwiftData @Model entity
│   ├── Product.swift           # SwiftData @Model entity
│   ├── Transaction.swift       # SwiftData @Model entity
│   ├── LineItem.swift          # Cart item struct
│   ├── ValidationService.swift # Name & phone validation/filtering
│   ├── BillCalculator.swift    # Totals, credits, stats logic
│   └── PrintManager.swift      # PDF generation + HTML template
├── View/
│   ├── ContentView.swift       # Customer list + search
│   ├── AddCustomerSheet.swift  # Add customer form with validation
│   ├── CustomerDetailView.swift # Customer detail + stats dashboard
│   ├── CreateBillView.swift    # Bill creation + product selection
│   └── NeumorphicDesign.swift  # 15+ reusable UI components
├── Controller/
│   ├── CustomerController.swift # Customer CRUD, validation state, payment
│   ├── BillController.swift     # Cart, product list, bill totals, save & print
├── BillingAppApp.swift          # @main entry point + default products
└── Assets.xcassets/             # App icon + accent color
```

## 📸 Screenshots

### 🏠 Home
![Home](Screenshots/Home.png)

### ➕ Add Customer
![Add Customer](Screenshots/AddCustomer.png)

### 👤 Customer Details
![Customer Details](Screenshots/CustomerDetails.png)

### 📋 Customer List
![Customer List](Screenshots/CustomerList.png)

### 🧾 Invoice Preview
![Invoice](Screenshots/Invoice.png)

## 🚀 How to Run

1. Clone this repository
2. Open `BillingApp.xcodeproj` in Xcode (15+)
3. Select an iPhone simulator (iOS 18.0+)
4. Press **⌘R** to build and run

## 🔮 Future Improvements

- ☁️ Firebase Cloud Sync & Backup
- 🔐 Authentication & Role-based Access
- 📊 Export Reports (CSV/PDF)
- 🌍 Multi-language Support (Telugu, Hindi)
- 📨 WhatsApp/SMS Invoice Sharing

## 📄 License

This project is available for educational and portfolio demonstration purposes.

---

<div align="center">

![Swift](https://img.shields.io/badge/Swift-F54A2A?style=flat-square&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-0A84FF?style=flat-square)
![MVC](https://img.shields.io/badge/MVC-4CAF50?style=flat-square)
![SwiftData](https://img.shields.io/badge/SwiftData-0A84FF?style=flat-square)

</div>
