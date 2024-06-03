//
//  FirstViewController.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit

class FirstViewController: UIViewController {
    //MARK: - Properties
  
    private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "First VC"
            label.textColor = .white  // 텍스트 색상 설정
            label.font = UIFont.interBoldFont(ofSize: 30)  // 폰트 설정
            label.textAlignment = .center  // 텍스트 중앙 정렬
            return label
        }()
    
    private let titleLabel2: UILabel = {
            let label = UILabel()
            label.text = "First VC"
            label.textColor = .white  // 텍스트 색상 설정
            label.font = UIFont.interBoldFont(ofSize: 30)  // 폰트 설정
            label.textAlignment = .center  // 텍스트 중앙 정렬
            return label
        }()
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        view.backgroundColor = .backgroundColor
        setupTitleLabel()
        fetchCurrencyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK: - Functions
    
    private func setupTitleLabel() {
           view.addSubview(titleLabel)
           view.addSubview(titleLabel2)
           titleLabel.translatesAutoresizingMaskIntoConstraints = false  // Auto Layout 활성화
           titleLabel2.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([
               titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
               titleLabel2.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
               titleLabel2.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 8)
           
           ])
       }
    
    
    private func fetchCurrencyData() {
        CurrencyService.shared.fetchExchangeRates(searchDate: nil) { [weak self] exchangeRates in
               DispatchQueue.main.async {
                   if let rates = exchangeRates {
                       
                       print("rates \(rates)")
                       
                       self?.titleLabel.text = rates.first?.cur_nm ?? "No data"
                       self?.titleLabel2.text = rates.first?.tts ?? "No data"
                   } else {
                       self?.titleLabel.text = "Failed to fetch data"
                       self?.titleLabel2.text = "Failed to fetch data"
                   }
               }
           }
       }
 

}
