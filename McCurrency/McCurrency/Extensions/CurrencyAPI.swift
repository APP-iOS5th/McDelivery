//
//  CurrencyAPI.swift
//  McCurrency
//
//  Created by Mac on 6/24/24.
//

import Foundation

//MARK: - 환율 API 불러오기
func fetchCurrencyData(for viewController: FirstViewController) {
    CurrencyService.shared.fetchExchangeRates { [weak viewController] exchangeRates in
        DispatchQueue.main.async {
            guard let viewController = viewController, let rates = exchangeRates else {
                print("Failed to fetch data")
                return
            }
            
            viewController.currencyDetails = createCurrencyDetails(from: rates)
            print("Updated Currency Details: \(viewController.currencyDetails)")
            
            // 날짜 확인 후 알림 표시
            let currentDate = Date()
            let validDate = CurrencyService.shared.getValidSearchDate(date: currentDate)
            let today = viewController.formattedDate(from: currentDate)
            if validDate != today {
                viewController.showAlertForPastData(date: validDate)
            }
            
            let usRateString = viewController.currencyDetails["미국"]?.tts.replacingOccurrences(of: ",", with: "")
            viewController.delegate?.didSendData(usRateString ?? "")
        }
    }
}

func createTtsDictionary(from rates: [ExchangeRate]) -> [String: String] {
    let dictionary = rates.reduce(into: [String: String]()) { (dict, rate) in
        dict[rate.cur_nm] = rate.tts
    }
    return dictionary
}

func createCurrencyDetails(from rates: [ExchangeRate]) -> [String: CurrencyDetail] {
    var details = [String: CurrencyDetail]()
    
    for rate in rates {
        let parts = rate.cur_nm.components(separatedBy: " ")
        guard parts.count >= 2 else { continue }
        
        let currencyUnit = parts.last!
        let countryName = parts.dropLast().joined(separator: " ")
        
        details[countryName] = CurrencyDetail(
            countryName: countryName,
            currencyName: rate.cur_unit,
            currencyUnit: currencyUnit,
            tts: rate.tts
        )
    }
    
    return details
}
