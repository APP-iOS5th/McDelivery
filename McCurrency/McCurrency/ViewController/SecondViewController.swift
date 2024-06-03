//
//  SecondViewController.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit


class SecondViewController: UIViewController {
    //MARK: - Properties
   
    private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Second VC"
            label.textColor = .white  // 텍스트 색상 설정
            label.font = UIFont.interBoldFont(ofSize: 30)  // 폰트 설정
            label.textAlignment = .center  // 텍스트 중앙 정렬
            return label
        }()
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        view.backgroundColor = .secondaryTextColor
        setupTitleLabel() 
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK: - Functions
    
    private func setupTitleLabel() {
           view.addSubview(titleLabel)  // 레이블을 뷰에 추가
           titleLabel.translatesAutoresizingMaskIntoConstraints = false  // Auto Layout 활성화
           
           NSLayoutConstraint.activate([
               titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),  // 가로 중앙 정렬
               titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)   // 세로 중앙 정렬
           ])
       }
    
    
    
}
