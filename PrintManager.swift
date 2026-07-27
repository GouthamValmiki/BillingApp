//
//  PrintManager.swift
//  BillingApp
//
//  Created by Goutham on 27/07/26.
//

import SwiftUI
import UIKit

class PrintManager {
    static let shared = PrintManager()
    
    func printBill(customerName: String, amount: Double, details: String) {
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = "AgriBill - \(customerName)"
        printInfo.outputType = .general
        
        let cleanDetails = details
            .replacingOccurrences(of: "\n", with: "<br>")
        
        let html = """
        <html>
        <head>
        <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        h1 { color: #2E7D32; border-bottom: 2px solid #2E7D32; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        td { padding: 6px; border-bottom: 1px dashed #ccc; }
        .total { font-size: 18px; font-weight: bold; color: #C62828; margin-top: 20px; }
        </style>
        </head>
        <body>
        <h1>Fertilizer & Seeds Store</h1>
        <p><strong>Bill To:</strong> \(customerName)</p>
        <p><strong>Date:</strong> \(Date().formatted(date: .long, time: .shortened))</p>
        <hr>
        <pre style="font-family: monospace;">\(cleanDetails)</pre>
        <div class="total">TOTAL BILL AMOUNT: $\(String(format: "%.2f", amount))</div>
        <hr>
        <p>Thank you for supporting local agriculture!</p>
        </body>
        </html>
        """
        
        let formatter = UIMarkupTextPrintFormatter(markupText: html)
        
        let controller = UIPrintInteractionController.shared
        controller.printInfo = printInfo
        controller.printFormatter = formatter
        controller.present(animated: true, completionHandler: nil)
    }
}
