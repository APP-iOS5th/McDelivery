//
//  FirstViewController.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit
import Foundation

protocol FirstViewControllerDelegate: AnyObject {
    func didSendData(_ data: String)
}

class FirstViewController: UIViewController {
    weak var delegate: FirstViewControllerDelegate?
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
    let fromAmountTextFieldLine = UIView()
    var toAmountLabels: [UILabel] = []
    var toAmountTopConstraints: [NSLayoutConstraint] = []
    let toAmountSuffixLabel = UILabel()
    let toAmountLabelsLine = UIView()
    let exchangeIcon = UIButton()
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
        setupSlotBoxesAndNumericViews(inside: bigMacCountbox, with: "$$$")
        setupHamburgerLabelsAndCoverBoxes()
        animateHamburgers()
        animateDigits()
        
        fetchCurrencyData(for: self)
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
        view.addSubview(fromAmountTextFieldLine)
        view.addSubview(exchangeIcon)
        view.addSubview(bigMacCountbox)
        view.addSubview(tooltipButton)
        view.addSubview(toCountryButton)
        view.addSubview(toAmountSuffixLabel)
        view.addSubview(toAmountLabelsLine)
        
        fromCountryLabel.translatesAutoresizingMaskIntoConstraints = false
        toCountryButton.translatesAutoresizingMaskIntoConstraints = false
        fromAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        fromAmountSuffixLabel.translatesAutoresizingMaskIntoConstraints = false
        fromAmountTextFieldLine.translatesAutoresizingMaskIntoConstraints = false
        toAmountSuffixLabel.translatesAutoresizingMaskIntoConstraints = false
        toAmountLabelsLine.translatesAutoresizingMaskIntoConstraints = false
        exchangeIcon.translatesAutoresizingMaskIntoConstraints = false
        bigMacCountbox.translatesAutoresizingMaskIntoConstraints = false
        tooltipButton.translatesAutoresizingMaskIntoConstraints = false
        
        fromCountryLabel.text = "🇰🇷 대한민국"
        fromCountryLabel.textColor = .white
        fromCountryLabel.font = UIFont.systemFont(ofSize: 16)
        
        toCountryButton.setTitle("🇺🇸 미국", for: .normal)
        toCountryButton.setTitleColor(.white, for: .normal)
        toCountryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        toCountryButton.backgroundColor = UIColor.toCountryButtonColor
        toCountryButton.layer.cornerRadius = 9
        toCountryButton.addTarget(self, action: #selector(toCountryButtonTapped), for: .touchUpInside)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.interMediumFont(ofSize: 40)
        ]
        
        fromAmountTextField.delegate = self
        fromAmountTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: placeholderAttributes)
        fromAmountTextField.textColor = .white
        fromAmountTextField.font = UIFont.interLightFont(ofSize: 36)
        fromAmountTextField.borderStyle = .none
        fromAmountTextField.keyboardType = .numberPad
        fromAmountTextField.textAlignment = .right
        
        fromAmountSuffixLabel.text = " 원"
        fromAmountSuffixLabel.textColor = .white
        fromAmountSuffixLabel.font = UIFont.interMediumFont(ofSize: 36)
        
        fromAmountTextFieldLine.backgroundColor = .secondaryTextColor
        
        toAmountSuffixLabel.text = " 달러"
        toAmountSuffixLabel.textColor = .white
        toAmountSuffixLabel.font = UIFont.interMediumFont(ofSize: 36)
        
        toAmountLabelsLine.backgroundColor = .secondaryTextColor
        
        exchangeIcon.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        exchangeIcon.tintColor = UIColor.secondaryTextColor
        exchangeIcon.setTitleColor(.white, for: .normal)
        exchangeIcon.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        exchangeIcon.isEnabled = false
        
        var bigMacBoxConfig = UIButton.Configuration.plain()
        bigMacBoxConfig.attributedTitle = AttributedString("개의 빅맥을\n구매할 수 있어요.", attributes: AttributeContainer([.font: UIFont.interThinFont(ofSize: 20)]))
        bigMacBoxConfig.baseForegroundColor = .white
        bigMacBoxConfig.background.backgroundColor = UIColor.boxColor
        bigMacBoxConfig.contentInsets = NSDirectionalEdgeInsets(top: 240, leading: 0, bottom: 0, trailing: 0)
        bigMacCountbox.configuration = bigMacBoxConfig
        bigMacCountbox.titleLabel?.numberOfLines = 0
        bigMacCountbox.titleLabel?.font = UIFont.interThinFont(ofSize: 20)
        bigMacCountbox.titleLabel?.textAlignment = .center
        bigMacCountbox.layer.cornerRadius = 20
        bigMacCountbox.layer.masksToBounds = true
        
        tooltipButton.setTitle(" 빅맥 지수란?", for: .normal)
        tooltipButton.setImage(UIImage(systemName: "questionmark.circle.fill"), for: .normal)
        tooltipButton.tintColor = UIColor.secondaryTextColor
        tooltipButton.setTitleColor(UIColor.secondaryTextColor, for: .normal)
        tooltipButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tooltipButton.addTarget(self, action: #selector(showTooltip), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            fromCountryLabel.centerXAnchor.constraint(equalTo: toCountryButton.centerXAnchor),
            fromCountryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            //대한민국
            
            toCountryButton.topAnchor.constraint(equalTo: exchangeIcon.bottomAnchor, constant: 48),
            toCountryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            toCountryButton.widthAnchor.constraint(equalToConstant: 100),
            toCountryButton.heightAnchor.constraint(equalToConstant: 32),
            //상대국 선택 버튼
            
            fromAmountTextField.topAnchor.constraint(equalTo: fromCountryLabel.bottomAnchor, constant: 20),
            fromAmountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            //원화 입력가능
            
            fromAmountSuffixLabel.centerYAnchor.constraint(equalTo: fromAmountTextField.centerYAnchor),
            fromAmountSuffixLabel.leadingAnchor.constraint(equalTo: fromAmountTextField.trailingAnchor, constant: 5),
            fromAmountSuffixLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            //원
            
            fromAmountTextFieldLine.topAnchor.constraint(equalTo: fromAmountTextField.bottomAnchor, constant: 4),
            fromAmountTextFieldLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 43),
            fromAmountTextFieldLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -42),
            fromAmountTextFieldLine.heightAnchor.constraint(equalToConstant: 1),
            //원화 텍스트필드 언더라인
            
            exchangeIcon.topAnchor.constraint(equalTo: fromAmountTextField.bottomAnchor, constant: 30),
            exchangeIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //환전버튼
            
            toAmountSuffixLabel.topAnchor.constraint(equalTo: bigMacCountbox.topAnchor, constant: 75),
            toAmountSuffixLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            //달러
            
            toAmountLabelsLine.topAnchor.constraint(equalTo: toAmountSuffixLabel.bottomAnchor, constant: 4),
            toAmountLabelsLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 43),
            toAmountLabelsLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -42),
            toAmountLabelsLine.heightAnchor.constraint(equalToConstant: 1),
            //상대국 통화 텍스트필드 언더라인
            
            bigMacCountbox.topAnchor.constraint(equalTo: fromAmountSuffixLabel.bottomAnchor, constant: 88),
            bigMacCountbox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bigMacCountbox.widthAnchor.constraint(equalToConstant: 357),
            bigMacCountbox.heightAnchor.constraint(equalToConstant: 353),
            //빅맥 갯수 바탕 박스
            
            tooltipButton.topAnchor.constraint(equalTo: bigMacCountbox.bottomAnchor, constant: 8),
            tooltipButton.trailingAnchor.constraint(equalTo: bigMacCountbox.trailingAnchor, constant: -10)
            //툴팁 버튼
        ])
    }
    //MARK: - toAmountLabels Motion
    internal func setuptoAmountLabels(with text: String) {
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
        
        for (_, digit) in digits.enumerated() {
            let toAmountLabel = createtoAmountLabel(with: String(digit))
            view.addSubview(toAmountLabel)
            
            let toAmountTopConstraint = toAmountLabel.topAnchor.constraint(equalTo: toAmountSuffixLabel.topAnchor, constant: -30)
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
        
        for label in toAmountLabels {
            view.bringSubviewToFront(label)
        }
        view.bringSubviewToFront(toAmountSuffixLabel)
        
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
    
    //MARK: - Tooltip
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
        let tooltipText = "빅맥 지수란,\n전 세계 맥도날드 빅맥 가격을 기준으로 각국 통화의 구매력을 비교하는 지표입니다."
        let attributedString = NSMutableAttributedString(string: tooltipText)
        let kernValue: CGFloat = 1.2
        attributedString.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: tooltipText.count))
        
        tooltipLabel.attributedText = attributedString
        tooltipLabel.textColor = .white
        tooltipLabel.font = UIFont.systemFont(ofSize: 14)
        tooltipLabel.numberOfLines = 0
        tooltipLabel.translatesAutoresizingMaskIntoConstraints = false
        
        newTooltipView.addSubview(tooltipLabel)
        
        NSLayoutConstraint.activate([
            tooltipLabel.topAnchor.constraint(equalTo: newTooltipView.topAnchor, constant: 10),
            tooltipLabel.bottomAnchor.constraint(equalTo: newTooltipView.bottomAnchor, constant: -8),
            tooltipLabel.leadingAnchor.constraint(equalTo: newTooltipView.leadingAnchor, constant: 8),
            tooltipLabel.trailingAnchor.constraint(equalTo: newTooltipView.trailingAnchor, constant: -8)
        ])
        
        view.addSubview(newTooltipView)
        
        NSLayoutConstraint.activate([
            newTooltipView.topAnchor.constraint(equalTo: tooltipButton.bottomAnchor, constant: 8),
            newTooltipView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newTooltipView.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        ])
        
        self.tooltipView = newTooltipView
    }
    
   

    
    internal func showAlertForPastData(date: String) {
        let alert = UIAlertController(title: "이전 날짜 데이터 사용", message: "현재 \(date)의 환율 정보를 표시하고 있습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

//MARK: - Animation
extension FirstViewController {
    internal func setupSlotBoxesAndNumericViews(inside backgroundView: UIView, with text: String) {
        // 기존의 숫자 뷰들을 제거
        for view in numericMotionViews {
            view.removeFromSuperview()
        }
        numericMotionViews.removeAll()
        
        // 슬롯 박스가 없을 경우 새로 생성
        if slotBoxes.isEmpty {
            for _ in 0..<4 {
                let slotbox = createSlotBox()
                backgroundView.addSubview(slotbox)
                slotBoxes.append(slotbox)
            }
            
            NSLayoutConstraint.activate([
                slotBoxes[0].leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
                slotBoxes[0].topAnchor.constraint(equalTo: toCountryButton.bottomAnchor, constant: 115),
                slotBoxes[0].widthAnchor.constraint(equalToConstant: 73),
                slotBoxes[0].heightAnchor.constraint(equalToConstant: 78),
                
                slotBoxes[1].leadingAnchor.constraint(equalTo: slotBoxes[0].trailingAnchor, constant: 5),
                slotBoxes[1].topAnchor.constraint(equalTo: toCountryButton.bottomAnchor, constant: 115),
                slotBoxes[1].widthAnchor.constraint(equalToConstant: 73),
                slotBoxes[1].heightAnchor.constraint(equalToConstant: 78),
                
                slotBoxes[2].leadingAnchor.constraint(equalTo: slotBoxes[1].trailingAnchor, constant: 5),
                slotBoxes[2].topAnchor.constraint(equalTo: toCountryButton.bottomAnchor, constant: 115),
                slotBoxes[2].widthAnchor.constraint(equalToConstant: 73),
                slotBoxes[2].heightAnchor.constraint(equalToConstant: 78),
                
                slotBoxes[3].leadingAnchor.constraint(equalTo: slotBoxes[2].trailingAnchor, constant: 5),
                slotBoxes[3].topAnchor.constraint(equalTo: toCountryButton.bottomAnchor, constant: 115),
                slotBoxes[3].widthAnchor.constraint(equalToConstant: 73),
                slotBoxes[3].heightAnchor.constraint(equalToConstant: 78),
            ])
        }
        
        // 새로운 텍스트에 따른 슬롯 텍스트 계산
        let slotTexts = calculateSlotTexts(from: text, numberOfSlots: 4)
        for (index, slotText) in slotTexts.enumerated() {
            let numericMotionView = NumericMotionView(
                frame: .zero,
                text: slotText,
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
    
    private func calculateSlotTexts(from text: String, numberOfSlots: Int) -> [String] {
        let numDigits = text.count
        var slotTexts = Array(repeating: "0", count: numberOfSlots)
        switch numDigits {
        case 1:
            slotTexts = Array(repeating: "0", count: numberOfSlots - 1) + [text]
        case 2:
            slotTexts = Array(repeating: "0", count: numberOfSlots - 2) + [String(text.first!), String(text.last!)]
        case 3:
            slotTexts = Array(repeating: "0", count: numberOfSlots - 3) + [
                String(text[text.startIndex]),
                String(text[text.index(text.startIndex, offsetBy: 1)]),
                String(text[text.index(text.startIndex, offsetBy: 2)])
            ]
        case 4:
            slotTexts = [
                String(text[text.startIndex]),
                String(text[text.index(text.startIndex, offsetBy: 1)]),
                String(text[text.index(text.startIndex, offsetBy: 2)]),
                String(text[text.index(text.startIndex, offsetBy: 3)])
            ]
        default:
            let partSize = numDigits / numberOfSlots
            let remainder = numDigits % numberOfSlots
            if remainder == 0 {
                for i in 0..<numberOfSlots {
                    slotTexts[i] = String(text[text.index(text.startIndex, offsetBy: i*partSize)..<text.index(text.startIndex, offsetBy: (i+1)*partSize)])
                }
            } else {
                for i in 0..<numberOfSlots {
                    let startIndex = text.index(text.startIndex, offsetBy: i * partSize + min(i, remainder))
                    let endIndex = text.index(startIndex, offsetBy: partSize + (i < remainder ? 1 : 0))
                    slotTexts[i] = String(text[startIndex..<endIndex])
                }
            }
        }
        return slotTexts
    }
    
    private func createSlotBox() -> UIView {
        let slotbox = UIView()
        slotbox.translatesAutoresizingMaskIntoConstraints = false
        slotbox.backgroundColor = UIColor.slotBox
        slotbox.layer.cornerRadius = 10
        slotbox.clipsToBounds = true
        return slotbox
    }
    
    internal func setupHamburgerLabelsAndCoverBoxes() {
        let hamburgerText = "🍔🍔🍔🍔"
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
                coverBox.widthAnchor.constraint(equalToConstant: 69),
                coverBox.heightAnchor.constraint(equalToConstant: 74)
            ])
        }
    }
    
    internal func animateHamburgers() {
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
}

//MARK: - UITextFieldDelegate
extension FirstViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.animateHamburgers()
        }
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
