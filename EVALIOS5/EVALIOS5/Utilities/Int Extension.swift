//
//  Int Extension.swift
//  EVALIOS5
//
//  Created by Student08 on 25/10/2023.
//

import Foundation

extension Int {
    func formatDiscount() -> String {
        let formattedNumber = "-" + String(self) + "%"
        return formattedNumber
    }
    
    func formatCentsToEuros(currency: String) -> String {
        let euros = Double(self) / 100.0
        let formattedString = String(format: "%.2f \(currency)", euros)
        return formattedString
    }
}
