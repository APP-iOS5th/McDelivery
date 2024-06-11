//
//  FirstViewController.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit

class FirstViewController: UIViewController {
    
    var totalWidth: CGFloat = 0
    var labelWidths: [CGFloat] = []
    var currencyDetails: [String: CurrencyDetail] = [:]
    
    var ttsDictionary: [String: String] = [:] {
        didSet {
            print("환율정보 업데이트 완료\(self)")
        }
    }
    //MARK: - Properties
    let fromCountryLabel = UILabel()
    
    let toCountryButton = UIButton()
    
    
    let countries: [(flag: String, name: String)] = [
        ("🇳🇴", "노르웨이"), ("🇲🇾", "말레이시아"),("🇺🇸", "미국"), ("🇸🇪", "스웨덴"),("🇨🇭", "스위스"),("🇬🇧", "영국"),("🇮🇩", "인도네시아"),("🇯🇵", "일본"),("🇨🇳", "중국"),("🇨🇦", "캐나다"),
        ("🇭🇰", "홍콩"),("🇹🇭","태국"),("🇦🇺", "호주"),("🇳🇿","뉴질랜드"),("🇸🇬","싱가포르")
        
    ]
    let fromAmountTextField = UITextField()
    let fromAmountSuffixLabel = UILabel()
    var toAmountLabels: [UILabel] = []
    var toAmountTopConstraints: [NSLayoutConstraint] = []
    let toAmountSuffixLabel = UILabel()
    let exchangeButton = UIButton()
    let bigMacCountbox = UIButton()
    let tooltipButton = UIButton()
    var tooltipView: UIView?
    var hamburgerTopConstraints: [NSLayoutConstraint] = []
    var hamburgerHeightConstraints: [NSLayoutConstraint] = []
    var hamburgerLabels: [UILabel] = []
    
    private var numericMotionViews: [NumericMotionView] = []
    private var triggerButton: UIButton!
    private var slotBoxes: [UIView] = []
    private var coverBoxes: [UIView] = []
    
    let maxCharacters = 10 //텍스트 필드 글자수 10자로 제한
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupUI()
        animatetoAmounts()
        setupSlotBoxesAndNumericViews(inside: bigMacCountbox)
        setupHamburgerLabelsAndCoverBoxes()
        bringHamburgersToFront()
        animateDigits()
        animateHamburgers()
        fetchCurrencyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK: - Functions
    
    func setupUI() {
        view.addSubview(fromCountryLabel)
        view.addSubview(fromAmountTextField)
        view.addSubview(fromAmountSuffixLabel)
        view.addSubview(toAmountSuffixLabel)
        view.addSubview(exchangeButton)
        view.addSubview(bigMacCountbox)
        view.addSubview(tooltipButton)
        view.addSubview(toCountryButton)
        
        fromCountryLabel.translatesAutoresizingMaskIntoConstraints = false
        toCountryButton.translatesAutoresizingMaskIntoConstraints = false
        fromAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        fromAmountSuffixLabel.translatesAutoresizingMaskIntoConstraints = false
        toAmountSuffixLabel.translatesAutoresizingMaskIntoConstraints = false
        exchangeButton.translatesAutoresizingMaskIntoConstraints = false
        bigMacCountbox.translatesAutoresizingMaskIntoConstraints = false
        tooltipButton.translatesAutoresizingMaskIntoConstraints = false
        
        fromCountryLabel.text = "🇰🇷 대한민국"
        fromCountryLabel.textColor = .white
        fromCountryLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        toCountryButton.setTitle("🇺🇸 미국", for: .normal)
        toCountryButton.setTitleColor(.white, for: .normal)
        toCountryButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        toCountryButton.backgroundColor = UIColor.boxColor
        toCountryButton.layer.cornerRadius = 5
        toCountryButton.addTarget(self, action: #selector(toCountryButtonTapped), for: .touchUpInside)
        
        fromAmountTextField.delegate = self
        
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.interBoldFont(ofSize: 40)
        ]
        fromAmountTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: placeholderAttributes)
        fromAmountTextField.textColor = .white
        fromAmountTextField.font = UIFont.interLightFont(ofSize: 36)
        fromAmountTextField.borderStyle = .none
        fromAmountTextField.keyboardType = .numberPad
        fromAmountTextField.textAlignment = .right
        
        fromAmountSuffixLabel.text = " 원"
        fromAmountSuffixLabel.textColor = .white
        fromAmountSuffixLabel.font = UIFont.interMediumFont(ofSize: 36)
        
        toAmountSuffixLabel.text = " 달러"
        toAmountSuffixLabel.textColor = .white
        toAmountSuffixLabel.font = UIFont.interMediumFont(ofSize: 36)
        
        exchangeButton.setImage(UIImage(systemName: "arrow.left.arrow.right"), for: .normal)
        exchangeButton.tintColor = UIColor.secondaryTextColor
        exchangeButton.setTitleColor(.white, for: .normal)
        exchangeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        exchangeButton.addTarget(self, action: #selector(exchangeButtonTapped), for: .touchUpInside)
        
        bigMacCountbox.titleLabel?.numberOfLines = 0
        bigMacCountbox.titleLabel?.textAlignment = .center
        
        bigMacCountbox.setTitle("개의 빅맥을\n살 수 있어요.", for: .normal)
        bigMacCountbox.setTitleColor(.white, for: .normal)
        bigMacCountbox.titleLabel?.font = UIFont.interLightFont(ofSize: 20)
        bigMacCountbox.backgroundColor = UIColor.boxColor
        bigMacCountbox.layer.cornerRadius = 20
        bigMacCountbox.titleEdgeInsets = UIEdgeInsets(top: 75, left: 0, bottom: 0, right: 0)
        
        tooltipButton.setTitle(" 빅맥지수란?", for: .normal)
        tooltipButton.setImage(UIImage(systemName: "questionmark.circle.fill"), for: .normal)
        tooltipButton.tintColor = UIColor.secondaryTextColor
        tooltipButton.setTitleColor(UIColor.secondaryTextColor, for: .normal)
        tooltipButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        tooltipButton.addTarget(self, action: #selector(showTooltip), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            fromCountryLabel.centerXAnchor.constraint(equalTo: toCountryButton.centerXAnchor),
            fromCountryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            //대한민국
            
            toCountryButton.topAnchor.constraint(equalTo: exchangeButton.bottomAnchor, constant: 17),
            toCountryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toCountryButton.widthAnchor.constraint(equalToConstant: 100),
            toCountryButton.heightAnchor.constraint(equalToConstant: 32),
            
            
            fromAmountTextField.topAnchor.constraint(equalTo: fromCountryLabel.bottomAnchor, constant: 20),
            fromAmountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            //원화 입력가능
            
            fromAmountSuffixLabel.centerYAnchor.constraint(equalTo: fromAmountTextField.centerYAnchor),
            fromAmountSuffixLabel.leadingAnchor.constraint(equalTo: fromAmountTextField.trailingAnchor, constant: 5),
            fromAmountSuffixLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            //원
            
            exchangeButton.topAnchor.constraint(equalTo: fromAmountTextField.bottomAnchor, constant: 20),
            exchangeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //환전버튼
            
            toAmountSuffixLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300),
            toAmountSuffixLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            //달러
            
            bigMacCountbox.topAnchor.constraint(equalTo: toAmountSuffixLabel.bottomAnchor, constant: 60),
            bigMacCountbox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bigMacCountbox.widthAnchor.constraint(equalToConstant: 327),
            bigMacCountbox.heightAnchor.constraint(equalToConstant: 216),
            
            tooltipButton.topAnchor.constraint(equalTo: bigMacCountbox.bottomAnchor, constant: 5),
            tooltipButton.trailingAnchor.constraint(equalTo: bigMacCountbox.trailingAnchor, constant: -10)
        ])
    }
    
    private func setuptoAmountLabels(with text: String) {
        let formattedText = text.formattedWithCommas()
        let digits = Array(formattedText)
        var previousLabel: UILabel? = nil
        
        var totalWidth: CGFloat = 0
        var labelWidths: [CGFloat] = []

        for label in toAmountLabels {
            label.removeFromSuperview()
        }
        toAmountLabels.removeAll()
        toAmountTopConstraints.removeAll()
        
        for digit in digits {
            let toAmountLabel = createtoAmountLabel(with: String(digit))
            let labelWidth = toAmountLabel.intrinsicContentSize.width
            labelWidths.append(labelWidth)
            totalWidth += labelWidth + 5
        }

        if !labelWidths.isEmpty {
            totalWidth -= 5
        }

        for (index, digit) in digits.enumerated() {
            let toAmountLabel = createtoAmountLabel(with: String(digit))
            view.addSubview(toAmountLabel)
            
            let toAmountTopConstraint = toAmountLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 330)
            toAmountTopConstraints.append(toAmountTopConstraint)
            toAmountLabels.append(toAmountLabel)
            
            var toAmountConstraints = [toAmountTopConstraint]
            
            if let previous = previousLabel {
                toAmountConstraints.append(toAmountLabel.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 1))
            } else {
                toAmountConstraints.append(toAmountLabel.leadingAnchor.constraint(equalTo: toAmountSuffixLabel.leadingAnchor, constant: -totalWidth + 13))
            }
            
            NSLayoutConstraint.activate(toAmountConstraints)
            previousLabel = toAmountLabel
        }

        if let lastLabel = toAmountLabels.last {
            NSLayoutConstraint.activate([
                lastLabel.trailingAnchor.constraint(equalTo: toAmountSuffixLabel.leadingAnchor, constant: -1)
            ])
        }
        
        animateDigits()
    }
    
    private func createtoAmountLabel(with text: String) -> UILabel {
        let toAmountLabel = UILabel()
        toAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        toAmountLabel.text = text
        toAmountLabel.font = UIFont.interLightFont(ofSize: 36)
        toAmountLabel.textColor = .white
        toAmountLabel.alpha = 0.0
        return toAmountLabel
    }
    
    
    @objc func exchangeButtonTapped() {
        guard let fromAmountText = fromAmountTextField.text, let fromAmount = Double(fromAmountText.replacingOccurrences(of: ",", with: "")) else { return }
        
        let exchangeRate = 1300.0
        let toAmount = fromAmount / exchangeRate
        
        let formattedToAmount = String(format: "%.2f", toAmount)
        let characters = Array(formattedToAmount)
        
        for (index, label) in toAmountLabels.enumerated() {
            if index < characters.count {
                label.text = String(characters[index])
            }
        }
        toAmountSuffixLabel.textColor = .white
    }
    
    @objc func showTooltip() {
        if let tooltipView = tooltipView {
            tooltipView.removeFromSuperview()
            self.tooltipView = nil
            return
        }
        
        let newTooltipView = UIView()
        newTooltipView.backgroundColor = UIColor.boxColor.withAlphaComponent(0.5)
        newTooltipView.layer.cornerRadius = 8
        newTooltipView.translatesAutoresizingMaskIntoConstraints = false
        
        let tooltipLabel = UILabel()
        tooltipLabel.text = "빅맥지수란, 전 세계 맥도날드 빅맥 가격을 기준으로 각국 통화의 구매력을 비교하는 지표입니다."
        tooltipLabel.textColor = .white
        tooltipLabel.font = UIFont.systemFont(ofSize: 12)
        tooltipLabel.numberOfLines = 0
        tooltipLabel.translatesAutoresizingMaskIntoConstraints = false
        
        newTooltipView.addSubview(tooltipLabel)
        
        NSLayoutConstraint.activate([
            tooltipLabel.topAnchor.constraint(equalTo: newTooltipView.topAnchor, constant: 8),
            tooltipLabel.bottomAnchor.constraint(equalTo: newTooltipView.bottomAnchor, constant: -8),
            tooltipLabel.leadingAnchor.constraint(equalTo: newTooltipView.leadingAnchor, constant: 8),
            tooltipLabel.trailingAnchor.constraint(equalTo: newTooltipView.trailingAnchor, constant: -8)
        ])
        
        view.addSubview(newTooltipView)
        
        NSLayoutConstraint.activate([
            newTooltipView.topAnchor.constraint(equalTo: tooltipButton.bottomAnchor, constant: 8),
            newTooltipView.centerXAnchor.constraint(equalTo: tooltipButton.centerXAnchor),
            newTooltipView.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        ])
        
        self.tooltipView = newTooltipView
    }
    
    private func animatetoAmounts() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for (index, label) in self.toAmountLabels.reversed().enumerated() {
                let topConstraint = self.toAmountTopConstraints.reversed()[index]
                UIView.animate(withDuration: 0.3, delay: Double(index) * 0.15, options: .curveEaseInOut, animations: {
                    topConstraint.constant += 30
                    label.alpha = 1.0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    
    //MARK: - 환율 API 불러오기
    private func fetchCurrencyData() {
        CurrencyService.shared.fetchExchangeRates { [weak self] exchangeRates in
            DispatchQueue.main.async {
                guard let self = self, let rates = exchangeRates else {
                    print("Failed to fetch data")
                    return
                }
                
                //                self.ttsDictionary = self.createTtsDictionary(from: rates)
                //                print("Updated TTS Dictionary: \(self.ttsDictionary)")
                
                self.currencyDetails = self.createCurrencyDetails(from: rates)
                print("Updated Currency Details: \(self.currencyDetails)")
                
                // 날짜 확인 후 알림 표시
                let currentDate = Date()
                let validDate = CurrencyService.shared.getValidSearchDate(date: currentDate)
                let today = self.formattedDate(from: currentDate)
                if validDate != today {
                    self.showAlertForPastData(date: validDate)
                }
            }
        }
    }
    
    
    private func showAlertForPastData(date: String) {
        let alert = UIAlertController(title: "이전 날짜 데이터 사용", message: "현재 \(date)의 환율 정보를 표시하고 있습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    //MARK: - 받아온 데이터 Dictionary 로 저장
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
  
    private func updateConversionAmount(text: String) {
        guard let countryButtonTitle = toCountryButton.title(for: .normal),
              let selectedCountry = extractCountryName(from: countryButtonTitle),
              let currencyDetail = currencyDetails[selectedCountry],
              let rate = Double(currencyDetail.tts.replacingOccurrences(of: ",", with: "")),
              let amount = Double(text.replacingOccurrences(of: ",", with: "")) else {
            print("환율 데이터가 없거나 입력값 문제 발생")
            return
        }

        // 100엔 단위로 표시된 환율을 한 엔 단위로 조정
        let adjustedRate = currencyDetail.currencyName.contains("JPY(100)") ? rate / 100 : rate

        let convertedAmount = amount / adjustedRate
        let formattedAmount = String(format: "%.2f", convertedAmount)
        print("환산된 금액: \(formattedAmount)")

        displayConvertedAmount(amount: formattedAmount)
    }
    
    private func displayConvertedAmount(amount: String) {
      setuptoAmountLabels(with: amount)
        
    }
    
    
    func extractCountryName(from title: String) -> String? {
        let components = title.split(separator: " ")
        guard components.count > 1 else { return nil }
        return String(components[1])
    }
    
    
    
    
    
}

//MARK: - Animation
extension FirstViewController {
    private func setupSlotBoxesAndNumericViews(inside backgroundView: UIView) {
        for _ in 0..<3 {
            let slotbox = createSlotBox()
            backgroundView.addSubview(slotbox)
            slotBoxes.append(slotbox)
        }
        
        NSLayoutConstraint.activate([
            slotBoxes[0].leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 51),
            slotBoxes[0].topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 33),
            slotBoxes[0].widthAnchor.constraint(equalToConstant: 73),
            slotBoxes[0].heightAnchor.constraint(equalToConstant: 78),
            
            slotBoxes[1].centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            slotBoxes[1].topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 33),
            slotBoxes[1].widthAnchor.constraint(equalToConstant: 73),
            slotBoxes[1].heightAnchor.constraint(equalToConstant: 78),
            
            slotBoxes[2].trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -51),
            slotBoxes[2].topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 33),
            slotBoxes[2].widthAnchor.constraint(equalToConstant: 73),
            slotBoxes[2].heightAnchor.constraint(equalToConstant: 78),
        ])
        
        let text = "143"
        let length = text.count / 3
        let remainder = text.count % 3
        let textParts = [
            String(text.prefix(length)),
            String(text.dropFirst(length).prefix(length)),
            String(text.dropFirst(length * 2))
        ]
        let adjustedTextParts = [
            textParts[0],
            textParts[1],
            textParts[2] + String(text.suffix(remainder))
        ]
        
        for (index, textPart) in adjustedTextParts.enumerated() {
            let numericMotionView = NumericMotionView(
                frame: .zero,
                text: textPart,
                trigger: false,
                duration: 1.2,
                speed: 0.005,
                textColor: .white
            )
            numericMotionView.translatesAutoresizingMaskIntoConstraints = false
            slotBoxes[index].addSubview(numericMotionView)
            numericMotionViews.append(numericMotionView)
            
            NSLayoutConstraint.activate([
                numericMotionView.centerXAnchor.constraint(equalTo: slotBoxes[index].centerXAnchor),
                numericMotionView.centerYAnchor.constraint(equalTo: slotBoxes[index].centerYAnchor)
            ])
        }
    }
    
    private func createSlotBox() -> UIView {
        let slotbox = UIView()
        slotbox.translatesAutoresizingMaskIntoConstraints = false
        slotbox.backgroundColor = UIColor.slotBox
        slotbox.layer.cornerRadius = 10
        slotbox.clipsToBounds = true
        return slotbox
    }
    
    private func setupHamburgerLabelsAndCoverBoxes() {
        let hamburgerText = "🍔🍔🍔"
        let hamburgers = Array(hamburgerText)
        
        for (index, hamburgerEmoji) in hamburgers.enumerated() {
            let coverBox = createCoverBox()
            bigMacCountbox.addSubview(coverBox)
            coverBoxes.append(coverBox)
            
            let hamburgerLabel = UILabel()
            hamburgerLabel.translatesAutoresizingMaskIntoConstraints = false
            hamburgerLabel.text = String(hamburgerEmoji)
            hamburgerLabel.font = UIFont.systemFont(ofSize: 55)
            bigMacCountbox.addSubview(hamburgerLabel)
            hamburgerLabels.append(hamburgerLabel)
            
            let hamburgerTopConstraint = hamburgerLabel.centerYAnchor.constraint(equalTo: slotBoxes[index].centerYAnchor)
            hamburgerTopConstraints.append(hamburgerTopConstraint)
            
            let hamburgerHeightConstraint = hamburgerLabel.heightAnchor.constraint(equalToConstant: 50)
            hamburgerHeightConstraints.append(hamburgerHeightConstraint)
            
            NSLayoutConstraint.activate([
                hamburgerLabel.centerXAnchor.constraint(equalTo: slotBoxes[index].centerXAnchor),
                hamburgerTopConstraint,
                hamburgerHeightConstraint
            ])
            
            NSLayoutConstraint.activate([
                coverBox.centerXAnchor.constraint(equalTo: hamburgerLabel.centerXAnchor),
                coverBox.centerYAnchor.constraint(equalTo: hamburgerLabel.centerYAnchor),
                coverBox.widthAnchor.constraint(equalToConstant: 73),
                coverBox.heightAnchor.constraint(equalToConstant: 78)
            ])
        }
    }
    
    private func createCoverBox() -> UIView {
        let coverBox = UIView()
        coverBox.translatesAutoresizingMaskIntoConstraints = false
        coverBox.backgroundColor = UIColor.slotBox
        coverBox.layer.cornerRadius = 10
        coverBox.clipsToBounds = true
        return coverBox
    }
    
    private func bringHamburgersToFront() {
        for hamburgerLabel in self.hamburgerLabels {
            bigMacCountbox.bringSubviewToFront(hamburgerLabel)
        }
    }

    private func animateDigits() {
           DispatchQueue.main.async {
               let reversedLabels = Array(self.toAmountLabels.reversed())
               let reversedTopConstraints = Array(self.toAmountTopConstraints.reversed())
               
               for (index, (label, topConstraint)) in zip(reversedLabels, reversedTopConstraints).enumerated() {
                   let delay = Double(index) * 0.1

                   UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseInOut, animations: {
                       topConstraint.constant += 30
                       label.alpha = 1.0
                       self.view.layoutIfNeeded()
                   }, completion: nil)
               }
           }
       }

    private func animateHamburgers() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            for (index, _) in self.hamburgerTopConstraints.enumerated() {
                let label = self.hamburgerLabels[index]
                let coverBox = self.coverBoxes[index]
                
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.hamburgerHeightConstraints[index].constant = 0
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    UIView.animate(withDuration: 1, animations: {
                        label.alpha = 0.0
                        coverBox.alpha = 0.0
                    })
                })
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.numericMotionViews.forEach { $0.animateText() }
            }
        }
    }
    
}

//MARK: - UITextFieldDelegate
extension FirstViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
   
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? "0"
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if updatedText.count > 13 {
            return false
        }
        
        let allowedCharacters = CharacterSet(charactersIn: "0123456789,").inverted
        let filtered = string.components(separatedBy: allowedCharacters).joined(separator: "")
        if string != filtered {
            return false
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        
        if let number = Double(updatedText.replacingOccurrences(of: ",", with: "")) {
            let formattedNumber = numberFormatter.string(from: NSNumber(value: number)) ?? ""
            textField.text = formattedNumber
            print("formattedNumber\(formattedNumber)")
            
            if let text = textField.text, !text.isEmpty {
                print("계산 시작\(text)")
                updateConversionAmount(text: text)
            }
            // updateConversionAmount(text: formattedNumber)
        } else {
            textField.text = ""
        }
        
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print("키보드 닫힘")
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
}

extension FirstViewController: CircularViewControllerDelegate {
    func countrySelected(_ countryName: String) {
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
                        updateConversionAmount(text: fromAmountText)
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
        pickerVC.delegate = self
        pickerVC.modalPresentationStyle = .overFullScreen
        pickerVC.modalTransitionStyle = .crossDissolve
        self.present(pickerVC, animated: true, completion: nil)
    }
    
}
