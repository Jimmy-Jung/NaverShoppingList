//
//  String+Extension.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import Foundation

extension String {
    
    var localized: Self {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(number: Int) -> Self {
        return String(format: self.localized, number)
    }
    
    var htmlToString: Self {
        guard let data = self.data(using: .utf8) else {
            return ""
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else { return "" }
        
        return  attributedString.string
    }
    
    func formatWithCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let number = Int(self) {
            return numberFormatter.string(from: NSNumber(value: number)) ?? self
        } else {
            return self
        }
    }
}
