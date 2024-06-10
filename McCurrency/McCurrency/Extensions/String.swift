//
//  String.swift
//  McCurrency
//
//  Created by 임재현 on 6/10/24.
//

import Foundation


extension String {
    func formattedWithCommas() -> String {
        guard let number = Int(self) else { return self }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? self
    }
}
