//
//  SecondViewController.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit

struct CountryDummy {
    var countryName: String
    let imageName: String
    let count: Int
}

class SecondViewController: UIViewController {
   
    
    // MARK: - Properties
    
    var dummyData: [CountryDummy] = [
        CountryDummy(countryName: "🇺🇸미국", imageName: "flag", count: 187),
        CountryDummy(countryName: "🇰🇷한국", imageName: "flag", count: 304),
        CountryDummy(countryName: "🇯🇵일본", imageName: "flag", count: 176)
    ]
    
    let countries: [(flag: String, name: String)] = [
        ("🇳🇴", "노르웨이"), ("🇲🇾", "말레이시아"),("🇺🇸", "미국"), ("🇸🇪", "스웨덴"),("🇨🇭", "스위스"),("🇬🇧", "영국"),("🇮🇩", "인도네시아"),("🇯🇵", "일본"),("🇨🇳", "중국"),("🇨🇦", "캐나다"),
        ("🇭🇰", "홍콩"),("🇹🇭","태국"),("🇦🇺", "호주"),("🇳🇿","뉴질랜드"),("🇸🇬","싱가포르")
        
    ]
    
    private let koreaLabel: UILabel = {
        let label = UILabel()
        label.text = "🇰🇷 대한민국"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var priceHStackView: UIStackView = UIStackView()
    private var priceVStackView: UIStackView = UIStackView()
    private var tableView: UITableView = UITableView()
    private let purchaseLabel: UILabel = UILabel()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        autoLayout()
        setupPriceViews()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.cellId)
        tableView.separatorStyle = .none
        
        setupAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Functions
    
    private func autoLayout() {
        view.addSubview(koreaLabel)
        
        NSLayoutConstraint.activate([
            koreaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            koreaLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150)
        ])
    }
    
    func setupPriceViews() {
        let textField = UITextField()
        textField.placeholder = "0"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 36)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "0", attributes: placeholderAttributes)
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 36)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .right
        
        let wonLabel = UILabel()
        wonLabel.text = "원"
        wonLabel.textColor = .white
        wonLabel.font = UIFont.systemFont(ofSize: 36)
        wonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceHStackView.addArrangedSubview(textField)
        priceHStackView.addArrangedSubview(wonLabel)
        
        priceHStackView.axis = .horizontal
        priceHStackView.distribution = .fill
        priceHStackView.alignment = .fill
        priceHStackView.spacing = 16
        
        let label = UILabel()
        label.text = "으로"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        priceVStackView.axis = .vertical
        priceVStackView.alignment = .trailing
        priceVStackView.distribution = .fill
        priceVStackView.spacing = 4
        
        priceVStackView.addArrangedSubview(priceHStackView)
        priceVStackView.addArrangedSubview(label)
        view.addSubview(priceVStackView)
        
        priceVStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceVStackView.topAnchor.constraint(equalTo: koreaLabel.bottomAnchor, constant: 16),
            priceVStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            priceVStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
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
    
    func setupAddButton() {
        let addButton = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        let plusImage = UIImage(systemName: "plus.circle", withConfiguration: configuration)
        addButton.setImage(plusImage, for: .normal)
        addButton.tintColor = .white
        addButton.addTarget(self, action: #selector(showCountryPicker), for: .touchUpInside)
        view.addSubview(addButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    
}

extension SecondViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? "" // 현재 텍스트 필드의 텍스트를 가져오는것.
        let updatedText = (currentText as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if updatedText.count > 13 {
            return false // 업데이트 된 텍스트의 길이가 13자를 초과하면 허용 안함.
        }
        
        let allowedCharacters = CharacterSet(charactersIn: "0123456789").inverted
        let filtered = string.components(separatedBy: allowedCharacters).joined(separator: "")
        if string != filtered { //숫자가 아니면 입력 허용 안함
            return false
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        //소숫점 표시
        
        if let number = Double(updatedText.replacingOccurrences(of: ",", with: "")) {
            let formattedNumber = numberFormatter.string(from: NSNumber(value: number)) ?? ""
            textField.text = formattedNumber
        } else {
            textField.text = ""
        }
        
        return false
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.cellId, for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        
        let data = dummyData[indexPath.row]
        cell.delegate = self
  //       cell.countryView.delegate = self
//        cell.countryView.configure(with: data.countryName, imageName: data.imageName)
        cell.toCountryButton.setTitle(data.countryName, for: .normal)
        cell.hamburgerImage.image = UIImage(named: "Hamburger")
        cell.countLabel.text = "\(data.count) 개"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // 셀 삭제 기능 추가
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dummyData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

}

extension SecondViewController: CircularViewControllerDelegate {
    @objc func showCountryPicker() {
        let pickerVC = CircularViewController()
        pickerVC.presentationContext = .fromSecondVCAddButton
        pickerVC.delegate = self
        pickerVC.modalPresentationStyle = .overFullScreen
        pickerVC.modalTransitionStyle = .crossDissolve
        self.present(pickerVC, animated: true, completion: nil)
    }
    
    func countrySelected(_ countryName: String) {
        let newCountry = CountryDummy(countryName: countryName, imageName: "flag", count: 0)
        dummyData.append(newCountry)
        let indexPath = IndexPath(row: dummyData.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension SecondViewController: CountryCellDelegate {
    
    
    func buttonTapped(_ cell: CountryCell) {
           let pickerVC = CircularViewController()
        pickerVC.presentationContext = .fromSecondVCCell
           pickerVC.delegate = self
           pickerVC.modalPresentationStyle = .overFullScreen
           pickerVC.modalTransitionStyle = .crossDissolve
           self.present(pickerVC, animated: true, completion: nil)
       }

       
    
}
