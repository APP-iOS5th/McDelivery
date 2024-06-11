//
//  McCount.swift
//  McCurrency
//
//  Created by SungWoonLee on 6/4/24.
//

import UIKit

class McCounter: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // 빅맥 지수 데이터
    let bigMacPricesInUSD: [String: Double] = [
        "Switzerland": 6.71,
        "Norway": 6.23,
        "Uruguay": 4.95,
        "Sweden": 6.15,
        "Euro Area": 5.50,
        "United States": 5.69,
        "Canada": 6.77,
        "Australia": 5.73,
        "Brazil": 4.92,
        "United Kingdom": 4.50,
        "South Korea": 4.30,
        "Saudi Arabia": 4.67,
        "Argentina": 1.77,
        "China": 3.37,
        "India": 1.89,
        "Indonesia": 2.36,
        "Philippines": 2.64,
        "Malaysia": 2.34,
        "Egypt": 1.46,
        "South Africa": 2.41,
        "Ukraine": 1.94,
        "Hong Kong": 2.81,
        "Vietnam": 2.84,
        "Japan": 3.50,
        "Romania": 2.21,
        "Azerbaijan": 3.40,
        "Jordan": 3.23,
        "Moldova": 1.78,
        "Oman": 3.58,
        "Taiwan": 2.59
    ]
    
    let countries = [
        "Switzerland", "Norway", "Uruguay", "Sweden", "Euro Area", "United States", "Canada", "Australia", "Brazil",
        "United Kingdom", "South Korea", "Saudi Arabia", "Argentina", "China", "India", "Indonesia", "Philippines",
        "Malaysia", "Egypt", "South Africa", "Ukraine", "Hong Kong", "Vietnam", "Japan", "Romania", "Azerbaijan",
        "Jordan", "Moldova", "Oman", "Taiwan"
    ]
    
    // 환율 (예시로 제공, 실제 환율은 변동될 수 있음)
    let exchangeRates: [String: Double] = [
        "KRW": 1338.90,
        "USD": 1.0
        // 추가적으로 필요한 환율 정보를 여기에 추가합니다.
    ]
    
    // UI 요소
    var krwTextField: UITextField!
    var countryPicker: UIPickerView!
    var resultLabel: UILabel!
    var calculateButton: UIButton!
    
    var selectedCountry: String?
    
    var circleView: UIView!
    var circleRadius: CGFloat = 200
    var circleCenter: CGPoint!  = CGPoint(x: 0, y: 0)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI 요소 초기화
        krwTextField = UITextField(frame: CGRect(x: 20, y: 80, width: self.view.frame.width - 40, height: 40))
        krwTextField.borderStyle = .roundedRect
        self.view.addSubview(krwTextField)
        
        countryPicker = UIPickerView(frame: CGRect(x: 20, y: 130, width: self.view.frame.width - 40, height: 200))
        self.view.addSubview(countryPicker)
        
        resultLabel = UILabel(frame: CGRect(x: 20, y: 340, width: self.view.frame.width - 40, height: 100))
        resultLabel.numberOfLines = 0
        resultLabel.layer.borderWidth = 1.0  // 테두리 두께 설정
        resultLabel.layer.borderColor = UIColor.black.cgColor  // 테두리 색상 설정
        self.view.addSubview(resultLabel)
        
        calculateButton = UIButton(frame: CGRect(x: 20, y: 600, width: self.view.frame.width - 40, height: 50))
        calculateButton.setTitle("계산하기", for: .normal)
        calculateButton.backgroundColor = .systemBlue
        calculateButton.addTarget(self, action: #selector(calculateButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(calculateButton)
        
        countryPicker.dataSource = self
        countryPicker.delegate = self
        selectedCountry = countries[0] // 초기 선택 나라 설정

    }
    

    @objc func calculateButtonPressed(_ sender: UIButton) {
        guard let krwText = krwTextField.text, let krwAmount = Double(krwText), let country = selectedCountry else {
            resultLabel.text = "한화"
            return
        }
        
        let usdAmount = krwAmount / exchangeRates["KRW"]! // 한화를 달러로 변환
        let numberOfBigMacsInKRW = usdAmount / 5.69 * 5500 / exchangeRates["KRW"]! // 한국에서 빅맥 개수 계산
        let bigMacPriceInSelectedCountry = bigMacPricesInUSD[country]! // 선택한 나라의 빅맥 가격
        
        let numberOfBigMacsInSelectedCountry = Int(numberOfBigMacsInKRW / bigMacPriceInSelectedCountry)
        
        resultLabel.text = "\(country)에서 약 \(numberOfBigMacsInSelectedCountry)개의 빅맥을 살 수 있습니다."
    }
    
    // UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    // UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = countries[row]
    }
}

