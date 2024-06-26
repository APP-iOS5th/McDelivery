//
//  CurrencyService.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit

class CurrencyService {
    
    let bigMacPricesInUSD: [String: Double] = [
        "노르웨이": 6.23,
        "말레이시아": 2.34,
        "미국": 5.69,
        "스웨덴": 6.15,
        "스위스": 6.71,
        "영국": 4.50,
        "인도네시아": 2.36,
        "일본": 3.50,
        "중국": 3.37,
        "캐나다": 6.77,
        "홍콩": 2.81,
        "태국": 4.40,
        "호주": 5.73,
        "뉴질랜드":5.33,
        "싱가포르":5.18
    ]
    
    static let shared = CurrencyService()
    private let apiKey = "QthgPxCuwN0r9U3l7zgYnf5XRtknKnM0"

    private init() {}
    
    func fetchExchangeRates(completion: @escaping ([ExchangeRate]?) -> Void) {
        let currentDate = Date()
        let validSearchDate = getValidSearchDate(date: currentDate)
        
        let urlString = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=\(apiKey)&data=AP01&searchdate=\(validSearchDate)"
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
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }

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
    
     func getValidSearchDate(date: Date) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let hour = calendar.component(.hour, from: date)
        if hour < 11 {
            let previousDay = calendar.date(byAdding: .day, value: -1, to: date)!
            return adjustDateForWeekendOrHoliday(date: previousDay)
        }
        
        return adjustDateForWeekendOrHoliday(date: date)
    }

    private func adjustDateForWeekendOrHoliday(date: Date) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if calendar.isDateInWeekend(date) {
            let weekday = calendar.component(.weekday, from: date)
            let daysToSubtract = weekday == 1 ? 2 : 1 // 일요일이면 2를 빼고, 토요일이면 1을 뺌
            let adjustedDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: date)!
            return dateFormatter.string(from: adjustedDate)
        }
        
        return dateFormatter.string(from: date)
    }
}
