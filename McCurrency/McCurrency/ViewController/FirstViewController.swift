//
//  FirstViewController.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties
    
    //    private let titleLabel: UILabel = {
    //        let label = UILabel()
    //        label.text = "First VC"
    //        label.textColor = .white
    //        label.font = UIFont.boldSystemFont(ofSize: 30)
    //        label.textAlignment = .center
    //        return label
    //    }()
    //
    //    private let titleLabel2: UILabel = {
    //        let label = UILabel()
    //        label.text = "First VC"
    //        label.textColor = .white
    //        label.font = UIFont.boldSystemFont(ofSize: 30)
    //        label.textAlignment = .center
    //        return label
    //    }()
    
    let fromCountryLabel = UILabel()
    let toCountryLabel = UILabel()
    let countryPickerView = UIPickerView()
    let countries: [(flag: String, name: String)] = [
        ("🇨🇭", "스위스"), ("🇳🇴", "노르웨이"), ("🇺🇾", "우루과이"), ("🇸🇪", "스웨덴"),
        ("🇪🇺", "유럽 연합"), ("🇺🇸", "미국"), ("🇨🇦", "캐나다"), ("🇦🇺", "오스트레일리아"),
        ("🇧🇷", "브라질"), ("🇬🇧", "영국"), ("🇰🇷", "대한민국"), ("🇸🇦", "사우디 아라비아"),
        ("🇦🇷", "아르헨티나"), ("🇨🇳", "중국"), ("🇮🇳", "인도"), ("🇮🇩", "인도네시아"),
        ("🇵🇭", "필리핀"), ("🇲🇾", "말레이시아"), ("🇪🇬", "이집트"), ("🇿🇦", "남아프리카 공화국"),
        ("🇺🇦", "우크라이나"), ("🇭🇰", "홍콩"), ("🇻🇳", "베트남"), ("🇯🇵", "일본"),
        ("🇷🇴", "루마니아"), ("🇦🇿", "아제르바이잔"), ("🇯🇴", "요르단"), ("🇲🇩", "몰도바"),
        ("🇴🇲", "오만"), ("🇹🇼", "대만")
    ]
    let fromAmountTextField = UITextField()
    let fromAmountSuffixLabel = UILabel()
    let toAmountLabel = UILabel()
    let toAmountSuffixLabel = UILabel()
    let exchangeButton = UIButton()
    let bigMacCountbox = UIButton()
    let tooltipButton = UIButton()
    
    let maxCharacters = 10 //글자수 최대를 10자로 제한.
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        //        fetchCurrencyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK: - Functions
    
    func setupUI() {
        //        view.addSubview(titleLabel)
        //        view.addSubview(titleLabel2)
        view.addSubview(fromCountryLabel)
        view.addSubview(toCountryLabel)
        view.addSubview(countryPickerView)
        view.addSubview(fromAmountTextField)
        view.addSubview(fromAmountSuffixLabel)
        view.addSubview(toAmountLabel)
        view.addSubview(toAmountSuffixLabel)
        view.addSubview(exchangeButton)
        view.addSubview(bigMacCountbox)
        view.addSubview(tooltipButton)
        
        //        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //        titleLabel2.translatesAutoresizingMaskIntoConstraints = false
        fromCountryLabel.translatesAutoresizingMaskIntoConstraints = false
        toCountryLabel.translatesAutoresizingMaskIntoConstraints = false
        countryPickerView.translatesAutoresizingMaskIntoConstraints = false
        fromAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        fromAmountSuffixLabel.translatesAutoresizingMaskIntoConstraints = false
        toAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        toAmountSuffixLabel.translatesAutoresizingMaskIntoConstraints = false
        exchangeButton.translatesAutoresizingMaskIntoConstraints = false
        bigMacCountbox.translatesAutoresizingMaskIntoConstraints = false
        tooltipButton.translatesAutoresizingMaskIntoConstraints = false
        
        fromCountryLabel.text = "🇰🇷 대한민국"
        fromCountryLabel.textColor = .white
        fromCountryLabel.font = UIFont.systemFont(ofSize: 14)
        
        toCountryLabel.text = "🇺🇸 미국"
        toCountryLabel.textColor = .white
        toCountryLabel.font = UIFont.systemFont(ofSize: 14)
        toCountryLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toCountryLabelTapped))
        toCountryLabel.addGestureRecognizer(tapGesture)
        
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        countryPickerView.isHidden = true
        
        fromAmountTextField.delegate = self
        
        fromAmountTextField.text = "1,300,000"
        fromAmountTextField.textColor = .white
        fromAmountTextField.font = UIFont.boldSystemFont(ofSize: 36)
        fromAmountTextField.borderStyle = .none
        fromAmountTextField.keyboardType = .numberPad
        fromAmountTextField.textAlignment = .right
        
        fromAmountSuffixLabel.text = " 원"
        fromAmountSuffixLabel.textColor = .white
        fromAmountSuffixLabel.font = UIFont.boldSystemFont(ofSize: 36)
        
        toAmountLabel.text = "1,000"
        toAmountLabel.textColor = .lightGray
        toAmountLabel.font = UIFont.boldSystemFont(ofSize: 36)
        
        toAmountSuffixLabel.text = " 달러"
        toAmountSuffixLabel.textColor = .lightGray
        toAmountSuffixLabel.font = UIFont.boldSystemFont(ofSize: 36)
        
        exchangeButton.setTitle("⇆", for: .normal)
        exchangeButton.setTitleColor(.white, for: .normal)
        exchangeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        exchangeButton.addTarget(self, action: #selector(exchangeButtonTapped), for: .touchUpInside)
        
        bigMacCountbox.setTitle("빅맥을 한개 살 수 있어요", for: .normal)
        bigMacCountbox.setTitleColor(.white, for: .normal)
        bigMacCountbox.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        bigMacCountbox.backgroundColor = .lightGray
        bigMacCountbox.layer.cornerRadius = 20
        
        tooltipButton.setTitle("빅맥지수란?", for: .normal)
        tooltipButton.setTitleColor(.white, for: .normal)
        tooltipButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tooltipButton.addTarget(self, action: #selector(showTooltip), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            //            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            //            titleLabel2.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            //            titleLabel2.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            fromCountryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            fromCountryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            toCountryLabel.topAnchor.constraint(equalTo: fromCountryLabel.bottomAnchor, constant: 10),
            toCountryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            countryPickerView.topAnchor.constraint(equalTo: toCountryLabel.bottomAnchor, constant: 10),
            countryPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            countryPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            fromAmountTextField.topAnchor.constraint(equalTo: countryPickerView.bottomAnchor, constant: 20),
            fromAmountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            fromAmountSuffixLabel.centerYAnchor.constraint(equalTo: fromAmountTextField.centerYAnchor),
            fromAmountSuffixLabel.leadingAnchor.constraint(equalTo: fromAmountTextField.trailingAnchor, constant: 5),
            fromAmountSuffixLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            exchangeButton.topAnchor.constraint(equalTo: fromAmountTextField.bottomAnchor, constant: 10),
            exchangeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            toAmountLabel.bottomAnchor.constraint(equalTo: exchangeButton.bottomAnchor, constant: 10),
            toAmountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                

            toAmountSuffixLabel.centerYAnchor.constraint(equalTo: toAmountLabel.centerYAnchor),
            toAmountSuffixLabel.leadingAnchor.constraint(equalTo: toAmountLabel.trailingAnchor, constant: 5),
            
            bigMacCountbox.topAnchor.constraint(equalTo: toAmountSuffixLabel.bottomAnchor, constant: 20),
            bigMacCountbox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bigMacCountbox.widthAnchor.constraint(equalToConstant: 300),
            bigMacCountbox.heightAnchor.constraint(equalToConstant: 180),
            
            tooltipButton.topAnchor.constraint(equalTo: bigMacCountbox.bottomAnchor, constant: 5),
            tooltipButton.trailingAnchor.constraint(equalTo: bigMacCountbox.trailingAnchor, constant: -10)
        ])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // 현재 텍스트 필드의 텍스트 길이를 가져옴
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= maxCharacters // 최대 글자 수를 초과하지 않도록 함
        }
    
    @objc func toCountryLabelTapped() {
        countryPickerView.isHidden = !countryPickerView.isHidden
    }
    
    @objc func exchangeButtonTapped() {
        guard let fromAmountText = fromAmountTextField.text, let fromAmount = Double(fromAmountText.replacingOccurrences(of: ",", with: "")) else { return }
        
        let exchangeRate = 1300.0
        let toAmount = fromAmount / exchangeRate
        
        toAmountLabel.text = String(format: "%.2f", toAmount)
        toAmountLabel.textColor = .white
        toAmountSuffixLabel.textColor = .white
    }
    
    @objc func showTooltip() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let title = "빅맥지수란?"
        let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        let attributedTitle = NSMutableAttributedString(string: title, attributes: titleFont)
        
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.message = "맥도날드의 대표적인 메뉴 빅맥 가격에 기초해, 영국 경제전문지 이코노미스트가 120여 개국의 물가 수준과 통화 가치를 비교하는 주요 지수로,  매 분기(1월,7월)마다 작성, 발표합니다! "
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //    private func fetchCurrencyData() {
    //        CurrencyService.shared.fetchExchangeRates(searchDate: nil) { [weak self] exchangeRates in
    //            DispatchQueue.main.async {
    //                if let rates = exchangeRates {
    //                    let ttsDictionary = self?.createTtsDictionary(from: rates)
    //
    //                    if let ttsDictionary = ttsDictionary {
    //                        let desiredKey = "바레인 디나르" // 원하는 키 설정
    //                        if let ttsValue = ttsDictionary[desiredKey] {
    //                            self?.titleLabel.text = desiredKey
    //                            self?.titleLabel2.text = ttsValue
    //                        } else {
    //                            self?.titleLabel.text = "No data"
    //                            self?.titleLabel2.text = "No data"
    //                        }
    //                        print("TTS Dictionary: \(ttsDictionary)")
    //                    }
    //                } else {
    //                    self?.titleLabel.text = "Failed to fetch data"
    //                    self?.titleLabel2.text = "Failed to fetch data"
    //                }
    //            }
    //        }
    //    }
    //
   func createTtsDictionary(from rates: [ExchangeRate]) -> [String: String] {
        let dictionary = rates.reduce(into: [String: String]()) { (dict, rate) in
            dict[rate.cur_nm] = rate.tts
        }
        return dictionary
    }
}

extension FirstViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let country = countries[row]
        return "\(country.flag) \(country.name)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCountry = countries[row]
        toCountryLabel.textColor = .white
        toCountryLabel.text = "\(selectedCountry.flag) \(selectedCountry.name)"
        countryPickerView.isHidden = true
    }
}
