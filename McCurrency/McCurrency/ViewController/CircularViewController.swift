//
//  SearchViewController.swift
//  McCurrency
//
//  Created by Mac on 6/9/24.
//

import UIKit
import AVKit

class CircularViewController: UIViewController, UITextFieldDelegate {
    
    let countries = [
        "Switzerland", "Norway", "Uruguay", "Sweden", "Euro Area", "United States", "Canada", "Australia", "Brazil",
        "United Kingdom", "South Korea", "Saudi Arabia", "Argentina", "China", "India", "Indonesia", "Philippines",
        "Malaysia", "Egypt", "South Africa", "Ukraine", "Hong Kong", "Vietnam", "Japan", "Romania", "Azerbaijan",
        "Jordan", "Moldova", "Oman", "Taiwan"
    ]
    var filteredCountries: [String] = []
    var labels: [UILabel] = []
    var lastAngle: CGFloat = 0
    var counter: CGFloat = 0
    var currentRotationAngle: CGFloat = 0
    
    var lastText : String?
    
    var resultLabel: UILabel!
    var centerLabel: UILabel!
    var searchBar: UISearchTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
//        
//        let backgroundView = UIView(frame: self.view.bounds)
//        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.contentView.addSubview(backgroundView)
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.frame = CGRect(x: -30, y: 55, width: 100, height: 50)
        self.view.addSubview(closeButton)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        
        searchBar = UISearchTextField(frame: CGRect(x: 45, y: 100, width: view.frame.width - 88, height: 40))
        searchBar.backgroundColor = .SearchBarColor
        searchBar.delegate = self
        searchBar.tintColor = .secondaryTextColor
        searchBar.textColor = .white
        searchBar.leftView?.tintColor = .secondaryTextColor
        self.view.addSubview(searchBar)
        
        searchBar.placeholder = ""
        
        // 초기화 시 모든 countries를 표시
        filteredCountries = countries
        
        displayCountries(filteredCountries)
        
        // 출력 확인용. 나중에 지우기
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
    
    func attributedString(for text: String, fittingWidth width: CGFloat, in label: UILabel) -> NSAttributedString {
        let font = label.font ?? UIFont.systemFont(ofSize: 17)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
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
        
        UIView.animate(withDuration: 0.2, animations:  {
            for (index, label) in self.labels.enumerated() {
                let baseAngle = 2 * CGFloat.pi * CGFloat(index) / CGFloat(self.labels.count) + self.currentRotationAngle
                let labelX = circleCenter.x + circleRadiusX * cos(baseAngle)
                let labelY = circleCenter.y + circleRadiusY * sin(baseAngle)
                
                label.center = CGPoint(x: labelX, y: labelY)
                label.transform = CGAffineTransform(rotationAngle: baseAngle)
            }
        }, completion: { _ in  self.labelTextSending()
        })
    }
    
    func labelTextSending()  {
        let circleCenter =  CGPoint(x: -70, y: view.frame.height / 2 + 20)
        let circleRadiusX: CGFloat = 250
        let circleRadiusY: CGFloat = 300
        let sendingNearOne = circleCenter.x + circleRadiusX
        
        for label in labels {
            if abs(label.center.x - sendingNearOne) < 5 {
                if let labelText = label.text {
                    resultLabel.text = "\(labelText)"
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
        // Clear existing labels
        for label in labels {
            label.removeFromSuperview()
        }
        labels.removeAll()
        
        let circleCenter = CGPoint(x: -70, y: view.frame.height / 2 + 20)
        let circleRadiusX: CGFloat = 250
        let circleRadiusY: CGFloat = 320
        
        let doubledCountries = countries + countries
        
        for (index, country) in doubledCountries.enumerated() {
            let angle = 2 * CGFloat.pi * CGFloat(index) / CGFloat(doubledCountries.count)
            let labelX = circleCenter.x + circleRadiusX * cos(angle)
            let labelY = circleCenter.y + circleRadiusY * sin(angle)
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 135, height: 20))
            label.center = CGPoint(x: labelX, y: labelY)
            label.text = country
            label.font = UIFont(name: AppFontName.interLight, size: 17) ?? UIFont.systemFont(ofSize: 17)
            label.textColor = .white
            label.textAlignment = .left
            label.attributedText = attributedString(for: country, fittingWidth: 125, in: label)
            label.transform = CGAffineTransform(rotationAngle: angle)
            
            self.labels.append(label)
            self.view.addSubview(label)
        }
    }
    
    // UITextFieldDelegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        filterCountries(for: currentText)
        return true
    }
}

