//
//  SecondViewController.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit

struct CountryDummy {
    let countryName: String
    let imageName: String
    let count: Int
}



class SecondViewController: UIViewController {
    //MARK: - Properties
    
    var dummyData: [CountryDummy] = [
        CountryDummy(countryName: "미국", imageName: "flag", count: 187),
        CountryDummy(countryName: "한국", imageName: "flag", count: 304),
        CountryDummy(countryName: "일본", imageName: "flag", count: 176)
    ]
    
    private let koreaFlagView:CountryFlagView = {
        let flagView = CountryFlagView()
        flagView.configure(with: "대한민국", imageName: "flag")
        return flagView
    }()
    
    private var priceHStackView: UIStackView = UIStackView()
    private var priceVStackView: UIStackView = UIStackView()
    private var tableView: UITableView = UITableView()
    private let purchaseLabel:UILabel = UILabel()
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        view.backgroundColor = .backgroundColor
        autoLayout()
        setupPriceViews()
     //   setupPurchaseLabel()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.cellId)
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK: - Functions
    
    private func autoLayout() {
        view.addSubview(koreaFlagView)
        
        
        
        koreaFlagView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            koreaFlagView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 32),
            koreaFlagView.topAnchor.constraint(equalTo: view.topAnchor,constant: 120),
            koreaFlagView.widthAnchor.constraint(equalToConstant: 150),
            koreaFlagView.heightAnchor.constraint(equalToConstant: 40)
            
            
        ])
        
        
        
        
    }
    
    func setupPriceViews() {
        let textField = UITextField()
        textField.placeholder = "금액을 입력하세요."
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 40)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "금액을 입력하세요", attributes: placeholderAttributes)
        textField.textColor = .mainColor
        textField.font = UIFont.systemFont(ofSize: 40)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .right
        
        let wonLabel = UILabel()
        wonLabel.text = "원"
        wonLabel.textColor = .white
        wonLabel.font = UIFont.systemFont(ofSize: 40)
        wonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceHStackView.addArrangedSubview(textField)
        priceHStackView.addArrangedSubview(wonLabel)
        
        priceHStackView.axis = .horizontal
        priceHStackView.distribution = .fill
        priceHStackView.alignment = .fill
        priceHStackView.spacing = 16
        
        let label = UILabel()
        label.text = "으로"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let priceVStackView = UIStackView()
        priceVStackView.axis = .vertical
        priceVStackView.alignment = .trailing
        priceVStackView.distribution = .fill
        priceVStackView.spacing = 4
        
        priceVStackView.addArrangedSubview(priceHStackView)
        priceVStackView.addArrangedSubview(label)
        view.addSubview(priceVStackView)
        
        priceVStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceVStackView.topAnchor.constraint(equalTo: koreaFlagView.bottomAnchor, constant: 16),
            priceVStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            priceVStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
      //  setupTableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .backgroundColor
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: priceVStackView.bottomAnchor, constant: 16),
                      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        
        ])
        
    }

    func setupTableView() {
        
        
    }
    
    
    
}


        
extension SecondViewController: UITextFieldDelegate {
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

        if updatedText.count > 13 {
            return false
        }
        
       
        let allowedCharacters = CharacterSet(charactersIn: "0123456789").inverted
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
        } else {
            textField.text = ""
        }
        
        return false
    }
}

        
extension SecondViewController:UITableViewDelegate,UITableViewDataSource {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.cellId, for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        
        let data = dummyData[indexPath.row]
        cell.delegate = self  // Delegate 설정
        cell.countryView.configure(with: data.countryName, imageName: data.imageName)
        cell.hamburgerImage.image = UIImage(named: "Hamburger")
        cell.countLabel.text = "\(data.count) 개"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    

    
}
        

extension SecondViewController:CountryCellDelegate {
    func countryViewDidTap(_ cell: CountryCell) {
     
        presentPickerViewController()
        
        
    }
    
    func presentPickerViewController() {
        let pickerVC = PickerViewController()
        pickerVC.modalPresentationStyle = .overFullScreen
        pickerVC.modalTransitionStyle = .crossDissolve
        self.present(pickerVC, animated: true, completion: nil)
    }
    
    
}
