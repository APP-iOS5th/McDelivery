//
//  SearchViewController.swift
//  McCurrency
//
//  Created by Mac on 6/9/24.
//



import UIKit
import AVKit

class CircularViewController: UIViewController {
    
    let countries = [
        "Switzerland", "Norway", "Uruguay", "Sweden", "Euro Area", "United States", "Canada", "Australia", "Brazil",
        "United Kingdom", "South Korea", "Saudi Arabia", "Argentina", "China", "India", "Indonesia", "Philippines",
        "Malaysia", "Egypt", "South Africa", "Ukraine", "Hong Kong", "Vietnam", "Japan", "Romania", "Azerbaijan",
        "Jordan", "Moldova", "Oman", "Taiwan"
    ]
    var labels: [UILabel] = []
    var lastAngle: CGFloat = 0
    var counter: CGFloat = 0
    var currentRotationAngle: CGFloat = 0
    
    var lastText : String?
    
    var resultLabel: UILabel!
    var centerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor.backgroundColor.withAlphaComponent(0.7)
        blurEffect()
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        closeButton.frame = CGRect(x: -30, y: 55, width: 100, height: 50)
        self.view.addSubview(closeButton)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        
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
        
        resultLabel = UILabel(frame: CGRect(x: 88, y: 66, width: 222, height: 33))
        resultLabel.numberOfLines = 0
        resultLabel.layer.borderWidth = 1.0
        resultLabel.layer.borderColor = UIColor.white.cgColor
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
    
    func labelTextSending() {
        let focusPoint = CGPoint(x: view.center.x, y: view.frame.height / 2 + 20)
        
        var closestLabel: UILabel?
        var minDistance = CGFloat.greatestFiniteMagnitude
        
        for label in labels {
            let distance = hypot(label.center.x - focusPoint.x, label.center.y - focusPoint.y)
            if distance < minDistance {
                closestLabel = label
                minDistance = distance
            }
        }
        
        if let focusedLabel = closestLabel {
            resultLabel.text = focusedLabel.text
            print("선택된 국가: \(String(describing: resultLabel.text))")
        }
    }
    
    func blurEffect() {
        
        let blurEffect = UIBlurEffect(style: .dark)
                      let blurEffectView = UIVisualEffectView(effect: blurEffect)
      
      
                      blurEffectView.frame = self.view.bounds
                      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      
      
                      view.addSubview(blurEffectView)
      
      
                      let backgroundView = UIView(frame: self.view.bounds)
                      backgroundView.backgroundColor = UIColor.backgroundColor.withAlphaComponent(0.3)
                      backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                      blurEffectView.contentView.addSubview(backgroundView)
        
        
        
        
    }
    
    
}
