//
//  PickerViewController.swift
//  McCurrency
//
//  Created by 임재현 on 6/5/24.
//

import UIKit

class PickerViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTransparentBackground()
        setupTextLabel()
        setupCloseButton()
       
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    private func setupTransparentBackground() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)  // 투명도 조절
    }
    
    private func setupTextLabel() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "환영합니다!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(label)
        
        // Constraints for the label
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupCloseButton() {
        let backButton = UIButton(type: .custom)
                backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
                backButton.tintColor = .black  // 아이콘 색상 설정
                backButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
                backButton.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(backButton)
                
               
                NSLayoutConstraint.activate([
                    backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                    backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)  
                ])
    }
    
    
}

