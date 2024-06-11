//
//  NumericMotionView.swift
//  McCurrency
//
//  Created by 조아라 on 6/10/24.
//

import UIKit

class NumericMotionView: UIView {
    var text: String = ""
    var trigger: Bool = false
    var duration: CGFloat = 1.0
    var speed: CGFloat = 0.1
    var textColor: UIColor = .white
    
    private var animatedText: String = ""
    private var randomCharacters: [Character] = Array("1234567890")
    private var animationID: String = UUID().uuidString
    private var label: UILabel!
    
    init(frame: CGRect, text: String, trigger: Bool, duration: CGFloat, speed: CGFloat, textColor: UIColor = .white) {
        self.text = text
        self.trigger = trigger
        self.duration = duration
        self.speed = speed
        self.textColor = textColor
        super.init(frame: frame)
        setupLabel()
        setRandomCharacters()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    private func setupLabel() {
        label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func animateText() {
        let currentID = animationID
        let characterCount = text.count
        for (index, charIndex) in text.indices.enumerated() {
            let delay = Double(index) * Double(duration) / Double(characterCount)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                var timerDuration: CGFloat = 0
                let timer = Timer.scheduledTimer(withTimeInterval: self.speed, repeats: true) { timer in
                    if currentID != self.animationID {
                        timer.invalidate()
                    } else {
                        timerDuration += self.speed
                        if timerDuration >= self.duration / CGFloat(characterCount) {
                            if self.text.indices.contains(charIndex) {
                                let actualCharacter = self.text[charIndex]
                                self.replaceCharacter(at: charIndex, character: actualCharacter)
                            }
                            timer.invalidate()
                        } else {
                            guard let randomCharacter = self.randomCharacters.randomElement() else { return }
                            self.replaceCharacter(at: charIndex, character: randomCharacter)
                        }
                    }
                }
                timer.fire()
            }
        }
    }
    
    private func setRandomCharacters() {
        animatedText = text
        for index in animatedText.indices {
            guard let randomCharacter = randomCharacters.randomElement() else { return }
            replaceCharacter(at: index, character: randomCharacter)
        }
        label.text = animatedText
    }
    
    private func replaceCharacter(at index: String.Index, character: Character) {
        guard animatedText.indices.contains(index) else { return }
        animatedText.replaceSubrange(index...index, with: String(character))
        DispatchQueue.main.async {
            self.label.text = self.animatedText
        }
    }
    
    func updateText(_ newText: String) {
        text = newText
        animatedText = newText
        animationID = UUID().uuidString
        setRandomCharacters()
        animateText()
    }
    
    func toggleTrigger() {
        trigger.toggle()
        animateText()
    }
}


