//
//  CircularViewController.swift
//  McCurrency
//
//  Created by 조아라 on 6/10/24.
//

import UIKit
import AVKit

protocol CircularViewControllerDelegate: AnyObject {
    func didSelectCountry(_ country: String)
    func modalDidDismiss()
}

class CircularViewController: UIViewController, UITextFieldDelegate {
    
    let countries = [
        "스위스 / CHF", "노르웨이 / NOK", "우루과이 / UYU", "스웨덴 / SEK", "유로 지역 / EUR", "미국 / USD",
        "캐나다 / CAD", "오스트레일리아 / AUD", "브라질 / BRL", "영국 / GBP", "대한민국 / KRW", "사우디 아라비아 / SAR",
        "아르헨티나 / ARS", "중국 / CNY", "인도 / INR", "인도네시아 / IDR", "필리핀 / PHP", "말레이시아 / MYR",
        "이집트 / EGP", "남아프리카 공화국 / ZAR", "우크라이나 / UAH", "홍콩 / HKD", "베트남 / VND", "일본 / JPY",
        "루마니아 / RON", "아제르바이잔 / AZN", "요르단 / JOD", "몰도바 / MDL", "오만 / OMR", "대만 / TWD"
    ]
    
    weak var delegate: CircularViewControllerDelegate?
    var filteredCountries: [String] = []
    var labels: [UILabel] = []
    var lastAngle: CGFloat = 0
    var counter: CGFloat = 0
    var currentRotationAngle: CGFloat = 0
    
    var lastText: String?
    
    var resultLabel: UILabel!
    var centerLabel: UILabel!
    var searchBar: UISearchTextField!
    var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        self.view.addSubview(blurEffectView)
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.frame = CGRect(x: -30, y: 55, width: 100, height: 50)
        self.view.addSubview(closeButton)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        
        searchBar = UISearchTextField(frame: CGRect(x: 45, y: 100, width: view.frame.width - 88, height: 40))
        searchBar.backgroundColor = .gray
        searchBar.delegate = self
        searchBar.tintColor = .secondaryTextColor
        searchBar.textColor = .white
        searchBar.leftView?.tintColor = .secondaryTextColor
        self.view.addSubview(searchBar)
        
        searchBar.placeholder = ""
        
        filteredCountries = countries
        
        displayCountries(filteredCountries)
        
        resultLabel = UILabel(frame: CGRect(x: 20, y: 150, width: view.frame.width - 40, height: 40))
        resultLabel.numberOfLines = 0
        resultLabel.layer.borderWidth = 1.0
        resultLabel.textColor = .white
        self.view.addSubview(resultLabel)
        
        centerLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height / 2, width: self.view.frame.width, height: 40))
        centerLabel.layer.borderColor = UIColor.white.cgColor
        centerLabel.layer.borderWidth = 1.0
        centerLabel.textColor = .white
        self.view.addSubview(centerLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.modalDidDismiss()
    }
    
    func attributedString(for text: String, fittingWidth width: CGFloat, in label: UILabel) -> NSAttributedString {
        let font = label.font ?? UIFont.systemFont(ofSize: 16)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: 1.8
        ]
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        return attributedText
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
        let centerX = UIScreen.main.bounds.minX
        let centerY = UIScreen.main.bounds.height / 2
        var angle = atan2(location.y - centerY, location.x - centerX) * 180 / .pi
        
        if angle < 0 { angle += 360 }
        let theta = lastAngle - angle
        lastAngle = angle
        
        if abs(theta) < 12 {
            counter += theta
        }
        if counter > 12  {
            rotateLabels(by: -1)
            AudioServicesPlaySystemSound(1104)
        } else if counter < -12  {
            rotateLabels(by: 1)
            AudioServicesPlaySystemSound(1104)
        }
        if abs(counter) > 12 { counter = 0 }
        if gesture.state == .ended {
            counter = 0
        }
    }
    
    func rotateLabels(by steps: Int) {
        let angleStep = 2 * CGFloat.pi / CGFloat(labels.count)
        currentRotationAngle += CGFloat(steps) * angleStep
        
        let circleCenter = CGPoint(x: -70, y: view.frame.height / 2 + 20)
        let circleRadiusX: CGFloat = 250
        let circleRadiusY: CGFloat = 320
        
        UIView.animate(withDuration: 0.4, animations: {  // 애니메이션 속도를 줄이기 위해 duration 증가
            for (index, label) in self.labels.enumerated() {
                let baseAngle = 2 * CGFloat.pi * CGFloat(index) / CGFloat(self.labels.count) + self.currentRotationAngle
                let labelX = circleCenter.x + circleRadiusX * cos(baseAngle)
                let labelY = circleCenter.y + circleRadiusY * sin(baseAngle)
                
                label.center = CGPoint(x: labelX, y: labelY)
                label.transform = CGAffineTransform(rotationAngle: baseAngle)
            }
        }, completion: { _ in self.labelTextSending() })
    }
    
    func labelTextSending()  {
        let circleCenter =  CGPoint(x: 0, y: view.frame.height / 2)
        let circleRadius: CGFloat = 250
        let sendingNearOne = circleCenter.x + circleRadius
        
        for label in labels {
            if abs(label.center.x - sendingNearOne) < 5 {
                if let labelText = label.text {
                    resultLabel.text = "\(labelText)"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.lastText =  "\(labelText)"
                        if self.resultLabel.text == self.lastText {
                            UIView.animate(withDuration: 0.2, delay: 0 ,options: .curveEaseInOut , animations: {
                                label.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                            } ) { _ in UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut
                            ) {
                                label.transform = CGAffineTransform.identity
                            }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func filterCountries(for searchText: String) {
        if searchText.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter { country in
                return country.lowercased().contains(searchText.lowercased())
            }
        }
        displayCountries(filteredCountries)
    }
    
    func displayCountries(_ countries: [String]) {
        for label in labels {
            label.removeFromSuperview()
        }
        labels.removeAll()
        
        let circleCenter = CGPoint(x: -70, y: view.frame.height / 2 + 20)
        let circleRadiusX: CGFloat = 250
        let circleRadiusY: CGFloat = 320
        
        for (index, country) in countries.enumerated() {
            let angle = 2 * CGFloat.pi * CGFloat(index) / CGFloat(countries.count)
            let labelX = circleCenter.x + circleRadiusX * cos(angle)
            let labelY = circleCenter.y + circleRadiusY * sin(angle)
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
            label.center = CGPoint(x: labelX, y: labelY)
            label.text = country
            label.font = UIFont(name: AppFontName.interLight, size: 17) ?? UIFont.systemFont(ofSize: 17)
            label.textColor = .white
            label.textAlignment = .left
            label.attributedText = attributedString(for: country, fittingWidth: 150, in: label)
            label.transform = CGAffineTransform(rotationAngle: angle)
            
            labels.append(label)
            view.addSubview(label)
        }
    }
    
    // UITextFieldDelegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        filterCountries(for: currentText)
        return true
    }
}
