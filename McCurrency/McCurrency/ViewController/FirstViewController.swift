//
//  FirstViewController.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties
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
    var toAmountLabels: [UILabel] = []
    var toAmountTopConstraints: [NSLayoutConstraint] = []
    let toAmountSuffixLabel = UILabel()
    let toCountryButton = UIButton()
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
        setuptoAmountLabels(with: "100000")
        animatetoAmounts()
        setupSlotBoxesAndNumericViews(inside: bigMacCountbox)
        setupHamburgerLabelsAndCoverBoxes()
        bringHamburgersToFront()
        animateDigits()
        animateHamburgers()
        //        fetchCurrencyData()

  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK: - Functions
    
    func setupUI() {
        view.addSubview(fromCountryLabel)
        view.addSubview(toCountryLabel)
        view.addSubview(countryPickerView)
        view.addSubview(fromAmountTextField)
        view.addSubview(fromAmountSuffixLabel)
        view.addSubview(toAmountSuffixLabel)
        view.addSubview(exchangeButton)
        view.addSubview(bigMacCountbox)
        view.addSubview(tooltipButton)
        view.addSubview(toCountryButton)
        toCountryButton.addSubview(toCountryLabel)
        
        fromCountryLabel.translatesAutoresizingMaskIntoConstraints = false
        toCountryButton.translatesAutoresizingMaskIntoConstraints = false
        toCountryLabel.translatesAutoresizingMaskIntoConstraints = false
        countryPickerView.translatesAutoresizingMaskIntoConstraints = false
        fromAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        fromAmountSuffixLabel.translatesAutoresizingMaskIntoConstraints = false
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
        
        toCountryButton.backgroundColor = UIColor.boxColor
        toCountryButton.layer.cornerRadius = 5
        toCountryButton.addTarget(self, action: #selector(toCountryButtonTapped), for: .touchUpInside)
        
        fromAmountTextField.delegate = self
        
        fromAmountTextField.text = "1,300,000"
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
            
            toCountryButton.bottomAnchor.constraint(equalTo: exchangeButton.bottomAnchor, constant: 30),
            toCountryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toCountryButton.widthAnchor.constraint(equalToConstant: 100),
            toCountryButton.heightAnchor.constraint(equalToConstant: 32),
            
            toCountryLabel.centerYAnchor.constraint(equalTo: toCountryButton.centerYAnchor),
            toCountryLabel.centerXAnchor.constraint(equalTo: toCountryButton.centerXAnchor),
            //미국
            
            countryPickerView.bottomAnchor.constraint(equalTo: toCountryLabel.topAnchor, constant: 300),
            countryPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            countryPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            //나라선택피커
            
            fromAmountTextField.topAnchor.constraint(equalTo: fromCountryLabel.bottomAnchor, constant: 20),
            fromAmountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            //원화 입력가능
            
            fromAmountSuffixLabel.centerYAnchor.constraint(equalTo: fromAmountTextField.centerYAnchor),
            fromAmountSuffixLabel.leadingAnchor.constraint(equalTo: fromAmountTextField.trailingAnchor, constant: 5),
            fromAmountSuffixLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            //원
            
            exchangeButton.topAnchor.constraint(equalTo: fromAmountTextField.bottomAnchor, constant: 30),
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 현재 텍스트 필드의 텍스트 길이를 가져옴
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= maxCharacters // 최대 글자 수를 초과하지 않도록 함
    }
    
    private func setuptoAmountLabels(with text: String) {
        let formattedText = text.formattedWithCommas()
        let digits = Array(formattedText)
        var previousLabel: UILabel? = nil
        
        for digit in digits {
            let toAmountLabel = createtoAmountLabel(with: String(digit))
            view.addSubview(toAmountLabel)
            
            let toAmountTopConstraint = toAmountLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 300)
            toAmountTopConstraints.append(toAmountTopConstraint)
            toAmountLabels.append(toAmountLabel)
            
            var toAmountConstraints = [toAmountTopConstraint]
            
            if let previous = previousLabel {
                toAmountConstraints.append(toAmountLabel.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 5))
            } else {
                toAmountConstraints.append(toAmountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 140))
            }
            
            NSLayoutConstraint.activate(toAmountConstraints)
            previousLabel = toAmountLabel
        }
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
        let pickerVC = CircularViewController()
        pickerVC.modalPresentationStyle = .overFullScreen
        pickerVC.modalTransitionStyle = .crossDissolve
        self.present(pickerVC, animated: true, completion: nil)
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

extension String {
    func formattedWithCommas() -> String {
        guard let number = Int(self) else { return self }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? self
    }
}

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
}

extension FirstViewController {
    private func bringHamburgersToFront() {
        for hamburgerLabel in self.hamburgerLabels {
            bigMacCountbox.bringSubviewToFront(hamburgerLabel)
        }
    }
    
    private func animateDigits() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for (index, topConstraint) in self.toAmountTopConstraints.reversed().enumerated() {
                let label = self.toAmountLabels.reversed()[index]
                UIView.animate(withDuration: 0.3, delay: Double(index) * 0.15, options: .curveEaseInOut, animations: {
                    topConstraint.constant += 30
                    label.alpha = 1.0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    private func animateHamburgers() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            for (index, topConstraint) in self.hamburgerTopConstraints.enumerated() {
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
