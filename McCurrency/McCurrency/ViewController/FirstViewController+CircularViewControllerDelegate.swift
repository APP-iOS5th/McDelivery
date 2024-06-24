//  FirstViewController+CircularViewControllerDelegate.swift
//  McCurrency
//
//  Created by Mac on 6/24/24.
//

import UIKit

extension FirstViewController: CircularViewControllerDelegate {
    
    func countrySelected(_ countryName: String, context: PresentationContext) {
        print("전달받은 국가 정보: \(countryName)")
        
        let components = countryName.split(separator: "/").map { $0.trimmingCharacters(in: .whitespaces) }
        if components.count == 2 {
            let country = components[0]
            let currencyCode = components[1]
            
            if let countryTuple = countries.first(where: { $0.name == country }) {
                let fullCountryName = "\(countryTuple.flag) \(countryTuple.name)"
                toCountryButton.setTitle(fullCountryName, for: .normal)
                toAmountSuffixLabel.text = currencyCode
                print("국가: \(fullCountryName), 통화: \(currencyCode)")
                
                // 자동으로 환율 계산을 트리거합니다.
                if let fromAmountText = fromAmountTextField.text, !fromAmountText.isEmpty {
                    self.updateConversionAmount(text: fromAmountText) // self를 사용하여 명시적으로 호출
                }
            } else {
                toCountryButton.setTitle("국가 정보 없음", for: .normal)
                toAmountSuffixLabel.text = "통화 정보 없음"
                print("국가 정보 미발견: \(country)")
            }
        } else {
            toCountryButton.setTitle("형식 오류", for: .normal)
            toAmountSuffixLabel.text = "통화 정보 없음"
            print("잘못된 형식: \(countryName)")
        }
    }
    
    @objc func toCountryButtonTapped() {
        let pickerVC = CircularViewController()
        pickerVC.presentationContext = .fromFirstVC
        pickerVC.delegate = self
        pickerVC.modalPresentationStyle = .overFullScreen
        pickerVC.modalTransitionStyle = .crossDissolve
        self.present(pickerVC, animated: true, completion: nil)
    }
}
