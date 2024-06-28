//  FirstViewController+Animations.swift
//  McCurrency
//
//  Created by Mac on 6/24/24.
//

import UIKit

extension FirstViewController {
    
    //MARK: - toAmountLabels Motion
    func setuptoAmountLabels(with text: String) {
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
    
    func createtoAmountLabel(with text: String) -> UILabel {
        let toAmountLabel = UILabel()
        toAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        toAmountLabel.text = text
        toAmountLabel.font = UIFont.interLightFont(ofSize: 36)
        toAmountLabel.textColor = .white
        toAmountLabel.alpha = 0.0
        return toAmountLabel
    }
    
//    func animatetoAmounts() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            for (index, label) in self.toAmountLabels.reversed().enumerated() {
//                let topConstraint = self.toAmountTopConstraints.reversed()[index]
//                UIView.animate(withDuration: 0.3, delay: Double(index) * 0.15, options: .curveEaseInOut, animations: {
//                    topConstraint.constant += 30
//                    label.alpha = 1.0
//                    self.view.layoutIfNeeded()
//                }, completion: nil)
//            }
//        }
//    }
    
    func setupSlotBoxesAndNumericViews(inside backgroundView: UIView, with text: String) {
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
                slotBoxes[0].leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 27),
                slotBoxes[0].topAnchor.constraint(equalTo: toCountryButton.bottomAnchor, constant: 115),
                slotBoxes[0].widthAnchor.constraint(equalToConstant: 73),
                slotBoxes[0].heightAnchor.constraint(equalToConstant: 78),
                
                slotBoxes[1].leadingAnchor.constraint(equalTo: slotBoxes[0].trailingAnchor, constant: 3),
                slotBoxes[1].topAnchor.constraint(equalTo: toCountryButton.bottomAnchor, constant: 115),
                slotBoxes[1].widthAnchor.constraint(equalToConstant: 73),
                slotBoxes[1].heightAnchor.constraint(equalToConstant: 78),
                
                slotBoxes[2].leadingAnchor.constraint(equalTo: slotBoxes[1].trailingAnchor, constant: 3),
                slotBoxes[2].topAnchor.constraint(equalTo: toCountryButton.bottomAnchor, constant: 115),
                slotBoxes[2].widthAnchor.constraint(equalToConstant: 73),
                slotBoxes[2].heightAnchor.constraint(equalToConstant: 78),
                
                slotBoxes[3].leadingAnchor.constraint(equalTo: slotBoxes[2].trailingAnchor, constant: 3),
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
    
    func calculateSlotTexts(from text: String, numberOfSlots: Int) -> [String] {
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
    
    func createSlotBox() -> UIView {
        let slotbox = UIView()
        slotbox.translatesAutoresizingMaskIntoConstraints = false
        slotbox.backgroundColor = UIColor.slotBox
        slotbox.layer.cornerRadius = 10
        slotbox.clipsToBounds = true
        return slotbox
    }
    
    func setupHamburgerLabelsAndCoverBoxes() {
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
            
            
            let hamburgerHeightConstraint = hamburgerLabel.heightAnchor.constraint(equalToConstant: 100)
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
    
    func animateHamburgers() {
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
    
    func createCoverBox() -> UIView {
        let coverBox = UIView()
        coverBox.translatesAutoresizingMaskIntoConstraints = false
        coverBox.backgroundColor = UIColor.slotBox
        coverBox.layer.cornerRadius = 10
        coverBox.clipsToBounds = true
        return coverBox
    }
    
    func bringHamburgersToFront() {
        for hamburgerLabel in self.hamburgerLabels {
            bigMacCountbox.bringSubviewToFront(hamburgerLabel)
        }
    }
    
    func animateDigits() {
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
