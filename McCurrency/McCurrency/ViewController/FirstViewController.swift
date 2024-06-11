//
//  FirstViewController.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit


class FirstViewController: UIViewController, UITextFieldDelegate {

    
    var ttsDictionary: [String: String] = [:] {
        didSet {
            print("환율정보 업데이트 완료\(self)")
        }
    }
    //MARK: - Properties
    let fromCountryLabel = UILabel()

    let toCountryButton = UIButton()
>>>>>>> 70329ef (toCountryButton edit)
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



  

=======
           setupSlotBoxesAndNumericViews(inside: bigMacCountbox)
                setupHamburgerLabelsAndCoverBoxes()
                bringHamburgersToFront()
                animateHamburgers()
                animateDigits()
              
                fetchCurrencyData()
        
        
        
        
//    
//        animatetoAmounts()
//        setupHamburgerLabelsAndCoverBoxes()
//        bringHamburgersToFront()
//        animateHamburgers()
//
//        self.animateHamburgers()
      //  setupSlotBoxesAndNumericViews(inside: bigMacCountbox)
       //   animateDigits()
       
>>>>>>> aa5f2bf (임시저장)
        fetchCurrencyData()
        //    setupTextField()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { // 데이터 로딩 후 딜레이를 주어 출력
//            self.animateHamburgers()
//            
//            print("currencyDetails:")
//               for (country, details) in self.currencyDetails {
//                   print("\(country): \(details)")
//               }
//           }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK: - Functions
    
    func setupUI() {
        view.addSubview(fromCountryLabel)

>>>>>>> 70329ef (toCountryButton edit)
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

            
            toCountryLabel.centerYAnchor.constraint(equalTo: toCountryButton.centerYAnchor),
            toCountryLabel.centerXAnchor.constraint(equalTo: toCountryButton.centerXAnchor),

            
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
<<<<<<< HEAD
    
    
    
=======

>>>>>>> 9ccf884 (toAmount Constraint edit)
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
            totalWidth += labelWidth + 1.5
        }

=======
        
        if !labelWidths.isEmpty {
            totalWidth -= 1
        }
        
 

            let toAmountLabel = createtoAmountLabel(with: String(digit))
            view.addSubview(toAmountLabel)
            
            let toAmountTopConstraint = toAmountLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 330)
            toAmountTopConstraints.append(toAmountTopConstraint)
            toAmountLabels.append(toAmountLabel)
            
            var toAmountConstraints = [toAmountTopConstraint]
            
            if let previous = previousLabel {
                toAmountConstraints.append(toAmountLabel.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 1))
            } else {

                toAmountConstraints.append(toAmountLabel.leadingAnchor.constraint(equalTo: toAmountSuffixLabel.leadingAnchor, constant: -totalWidth))

            }

            NSLayoutConstraint.activate(toAmountConstraints)
            previousLabel = toAmountLabel
        }
<<<<<<< HEAD
        animateDigits()
=======

        if let lastLabel = toAmountLabels.last {
            NSLayoutConstraint.activate([
                lastLabel.trailingAnchor.constraint(equalTo: toAmountSuffixLabel.leadingAnchor, constant: -1)
            ])
        }
>>>>>>> 9ccf884 (toAmount Constraint edit)
        
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

    @objc func toCountryButtonTapped() {
        let viewController = CircularViewController()
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true, completion: nil)
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

//
//    private func updateConversionAmount(text: String) {
//        guard let selectedCountry = toCountryLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines),
//              let currencyDetail = currencyDetails[selectedCountry],
//              let rate = Double(currencyDetail.tts.replacingOccurrences(of: ",", with: "")),
//              let amount = Double(text.replacingOccurrences(of: ",", with: "")) else {
//            print("환율 데이터가 없거나 입력값 문제 발생")
//            print("선택된 국가: \(String(describing: toCountryLabel.text))")
//            print("사전에서 찾은 환율: \(String(describing: currencyDetails[toCountryLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]))")
//            return
//        }
//
//        let convertedAmount = amount / rate
//        let formattedAmount = String(format: "%.2f", convertedAmount)
//        print("환산된 금액: \(formattedAmount)")
//        displayConvertedAmount(amount: formattedAmount)
//    }
    
    private func updateConversionAmount(text: String) {
        guard let rateUSD = Double(currencyDetails["미국"]?.tts.replacingOccurrences(of: ",", with: "") ?? ""),
              let amount = Double(text.replacingOccurrences(of: ",", with: "")),
              let selectedCountry = toCountryLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let bigMacPrice = McCounter_addedSearch().bigMacPricesInUSD[selectedCountry] else {
            print("환율 데이터가 없거나 입력값 문제 발생")
            return
        }

        // 입력된 한화를 미국 달러로 환산
        let convertedAmountInUSD = amount / rateUSD
        // 환산된 달러로 해당 나라의 빅맥을 몇 개 살 수 있는지 계산
        let bigMacsYouCanBuy = Int(convertedAmountInUSD / bigMacPrice)

        let formattedAmount = String(format: "%.2f", convertedAmountInUSD)
        print("환산된 금액 (USD): \(formattedAmount)")
        print("해당 국가에서 구매 가능한 빅맥 수: \(bigMacsYouCanBuy)")

        displayConvertedAmount(amount: formattedAmount)
 //      setupSlotBoxesAndNumericViews(inside: bigMacCountbox, withBigMacCount: bigMacsYouCanBuy)
       // displayBigMacCount(bigMacsYouCanBuy)
    }

    
    private func displayConvertedAmount(amount: String) {
        setuptoAmountLabels(with: amount)
        
    }

}





//MARK: - Animation
extension FirstViewController {
    
//    private func setupSlotBoxesAndNumericViews(inside backgroundView: UIView, withBigMacCount bigMacCount: Int) {
//        for _ in 0..<3 {
//            let slotbox = createSlotBox()
//            backgroundView.addSubview(slotbox)
//            slotBoxes.append(slotbox)
//        }
//
//        NSLayoutConstraint.activate([
//            slotBoxes[0].leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 51),
//            slotBoxes[0].topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 33),
//            slotBoxes[0].widthAnchor.constraint(equalToConstant: 73),
//            slotBoxes[0].heightAnchor.constraint(equalToConstant: 78),
//            
//            slotBoxes[1].centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
//            slotBoxes[1].topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 33),
//            slotBoxes[1].widthAnchor.constraint(equalToConstant: 73),
//            slotBoxes[1].heightAnchor.constraint(equalToConstant: 78),
//            
//            slotBoxes[2].trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -51),
//            slotBoxes[2].topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 33),
//            slotBoxes[2].widthAnchor.constraint(equalToConstant: 73),
//            slotBoxes[2].heightAnchor.constraint(equalToConstant: 78),
//        ])
//
//        // bigMacText 업데이트
//             bigMacText = String(bigMacCount)
//             let textParts = bigMacText.map { String($0) } // 숫자를 문자열 배열로 분할
//        
//       // let textParts = text.map { String($0) } // 숫자를 문자열 배열로 분할
//
//        for (index, textPart) in textParts.enumerated() {
//            let numericMotionView = NumericMotionView(
//                frame: .zero,
//                text: textPart,
//                trigger: false,
//                duration: 1.2,
//                speed: 0.005,
//                textColor: .white
//            )
//            numericMotionView.translatesAutoresizingMaskIntoConstraints = false
//            slotBoxes[index % slotBoxes.count].addSubview(numericMotionView)
//            numericMotionViews.append(numericMotionView)
//
//            NSLayoutConstraint.activate([
//                numericMotionView.centerXAnchor.constraint(equalTo: slotBoxes[index % slotBoxes.count].centerXAnchor),
//                numericMotionView.centerYAnchor.constraint(equalTo: slotBoxes[index % slotBoxes.count].centerYAnchor)
//            ])
//        }
//    }
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
        
        let text = "0000"
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
    
//    private func setupSlotBoxesAndNumericViews(inside backgroundView: UIView, number: Int) {
//        // 숫자를 문자열로 변환
//        let text = String(number)
//        let numberOfDigits = text.count
//        let numberOfBoxes = slotBoxes.count // 일반적으로 3으로 설정되어 있음을 가정
//
//        // 각 슬롯에 표시할 숫자 분배 계산
//        var digitsForSlots = Array(repeating: "", count: numberOfBoxes)
//
//        // 숫자를 슬롯에 균등하게 분배
//        for (index, digit) in text.enumerated().reversed() {
//            let slotIndex = (numberOfDigits - 1 - index) % numberOfBoxes
//            digitsForSlots[slotIndex] = String(digit) + digitsForSlots[slotIndex]
//        }
//
//        // 각 슬롯에 숫자를 설정하고 애니메이션 뷰 추가
//        for (index, slotText) in digitsForSlots.enumerated() {
//            let numericMotionView = NumericMotionView(
//                frame: .zero,
//                text: slotText,
//                trigger: false,
//                duration: 1.2,
//                speed: 0.005,
//                textColor: .white
//            )
//            numericMotionView.translatesAutoresizingMaskIntoConstraints = false
//            slotBoxes[index].addSubview(numericMotionView)
//            numericMotionViews.append(numericMotionView)
//
//            NSLayoutConstraint.activate([
//                numericMotionView.centerXAnchor.constraint(equalTo: slotBoxes[index].centerXAnchor),
//                numericMotionView.centerYAnchor.constraint(equalTo: slotBoxes[index].centerYAnchor)
//            ])
//        }
//    }
    
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
           let components = countryName.split(separator: "/").map { $0.trimmingCharacters(in: .whitespaces) }
           if components.count == 2 {
               toCountryLabel.text = components[0] // 나라 이름
               toAmountSuffixLabel.text = components[1] // 통화 단위
           } else {
               toCountryLabel.text = countryName
               toAmountSuffixLabel.text = "통화 정보 없음"
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



