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
    
    internal var numericMotionViews: [NumericMotionView] = []
    internal var triggerButton: UIButton!
    internal var slotBoxes: [UIView] = []
    internal var coverBoxes: [UIView] = []
    
    let maxCharacters = 10 //텍스트 필드 글자수 10자로 제한
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        animatetoAmounts()
//        setuptoAmountLabels()
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

