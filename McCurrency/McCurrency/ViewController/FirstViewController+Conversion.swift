//
//  FirstViewController+Conversion.swift
//  McCurrency
//
//  Created by Mac on 6/24/24.
//

import UIKit

extension FirstViewController {
    
    func updateConversionAmount(text: String) {
        guard let countryButtonTitle = toCountryButton.title(for: .normal),
              let selectedCountry = extractCountryName(from: countryButtonTitle),
              let currencyDetail = currencyDetails[selectedCountry],
              let rate = Double(currencyDetail.tts.replacingOccurrences(of: ",", with: "")),
              let amount = Double(text.replacingOccurrences(of: ",", with: "")),
              let bigMacPrice = McCounter().bigMacPricesInUSD[selectedCountry],
              let usRateString = currencyDetails["미국"]?.tts.replacingOccurrences(of: ",", with: ""),
              let usRate = Double(usRateString) else {
            print("환율 데이터가 없거나 입력값 문제 발생")
            return
        }
        
        let adjustedRate = currencyDetail.currencyName.contains("JPY(100)") ? rate / 100 : rate
        let convertedAmount = amount / adjustedRate
        let formattedAmount = String(format: "%.2f", convertedAmount)
        print("환산된 금액: \(formattedAmount)")
        
        let usdAmount = amount / usRate
        let formattedUSDAmount = String(format: "%.2f", usdAmount)
        print("USD로 환산된 금액: \(formattedUSDAmount)")
        
        let bigMacsCanBuy = Int(usdAmount / bigMacPrice)
        print("구매 가능한 빅맥 개수: \(bigMacsCanBuy)")
        
        displayConvertedAmount(amount: formattedUSDAmount)
        setupHamburgerLabelsAndCoverBoxes()
        
        animateHamburgers()
        setupSlotBoxesAndNumericViews(inside: bigMacCountbox, with: "\(bigMacsCanBuy)")
    }
    
    func displayConvertedAmount(amount: String) {
        setuptoAmountLabels(with: amount)
    }
    
    func extractCountryName(from title: String) -> String? {
        let components = title.split(separator: " ")
        guard components.count > 1 else { return nil }
        return String(components[1])
    }
}
