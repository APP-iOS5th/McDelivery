//
//  SecondViewController.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit

struct SelectedCountry: Codable {
    var countryName: String
    let count: Int
}

class SecondViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var selectedCountry: [SelectedCountry] = []
    
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
        setupEmptyView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.cellId)
        tableView.separatorStyle = .none
        
        setupAddButton()
        let loadedCountries = loadCountries()
        self.selectedCountry = loadedCountries
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Functions
    private func setupEmptyView() {
        let label = UILabel()
        label.text = "나라를 선택하세요!"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        tableView.backgroundView = label
        tableView.backgroundView?.isHidden = true
    }
    private func autoLayout() {
        view.addSubview(koreaLabel)
        
        NSLayoutConstraint.activate([
            koreaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            koreaLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150)
        ])
    }
    
    func setupPriceViews() {
        let textField = UITextField()
        textField.keyboardType = .numberPad
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
    
    func saveCountries(countries: [SelectedCountry]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(countries) {
            UserDefaults.standard.set(encoded, forKey: "SelectedCountries")
        }
    }
    
    
    func loadCountries() -> [SelectedCountry] {
        if let savedCountries = UserDefaults.standard.object(forKey: "SelectedCountries") as? Data {
            let decoder = JSONDecoder()
            if let loadedCountries = try? decoder.decode([SelectedCountry].self, from: savedCountries) {
                return loadedCountries
            }
        }
        return []
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
        let count = selectedCountry.count
            tableView.backgroundView?.isHidden = count > 0
            return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.cellId, for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        
        let data = selectedCountry[indexPath.row]
        cell.delegate = self
        cell.toCountryButton.tag = indexPath.row
        cell.toCountryButton.addTarget(self, action: #selector(countryButtonTapped(_:)), for: .touchUpInside)
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
            selectedCountry.remove(at: indexPath.row)
            saveCountries(countries: selectedCountry)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    @objc func countryButtonTapped(_ sender: UIButton) {
            let indexPath = IndexPath(row: sender.tag, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            let pickerVC = CircularViewController()
            pickerVC.delegate = self
            pickerVC.presentationContext = .fromSecondVCCell
            present(pickerVC, animated: true, completion: nil)
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
    
    func countrySelected(_ countryName: String, context: PresentationContext) {
        let components = countryName.split(separator: "/").map { $0.trimmingCharacters(in: .whitespaces) }
        let countryOnly = components[0]

        switch context {
        case .fromSecondVCAddButton:
            // 새 국가를 목록에 추가하는 로직
            if let countryTuple = countries.first(where: { $0.name == countryOnly }) {
                let fullCountryName = "\(countryTuple.flag) \(countryTuple.name)"
                let newCountry = SelectedCountry(countryName: fullCountryName, count: 0)
                selectedCountry.append(newCountry)
                saveCountries(countries: selectedCountry)
                let indexPath = IndexPath(row: selectedCountry.count - 1, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        case .fromSecondVCCell:
            // 선택된 셀의 국가를 업데이트하는 로직
            if let indexPath = tableView.indexPathForSelectedRow,
               let countryTuple = countries.first(where: { $0.name == countryOnly }) {
                let fullCountryName = "\(countryTuple.flag) \(countryTuple.name)"
                selectedCountry[indexPath.row].countryName = fullCountryName
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        default:
            break
        }
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
extension SecondViewController:FirstViewControllerDelegate {
    func didSendData(_ data: String) {
        print("data\(data)")
    }
    
    
}
