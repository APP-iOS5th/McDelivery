//
//  CurrencyService.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit

class CurrencyService {
    
    static let shared = CurrencyService()
    private let apiKey = "QthgPxCuwN0r9U3l7zgYnf5XRtknKnM0"
    
    private init() {}
    
    func fetchExchangeRates(searchDate: String?, completion: @escaping ([ExchangeRate]?) -> Void) {
        var urlString = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=\(apiKey)&data=AP01"
        if let date = searchDate {
            urlString += "&searchdate=\(date)"
        }

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)") // HTTP 상태 코드 로깅
            }

            // 원시 데이터 문자열 로깅
            let rawString = String(data: data, encoding: .utf8) ?? "Failed to convert data to string"
            print("Raw response string: \(rawString)")

            do {
                let exchangeRates = try JSONDecoder().decode([ExchangeRate].self, from: data)
                completion(exchangeRates)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

