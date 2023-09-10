//
//  String+Extension.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import Foundation

extension String {
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
