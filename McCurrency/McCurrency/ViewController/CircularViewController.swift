//
//  SearchViewController.swift
//  McCurrency
//
//  Created by Mac on 6/9/24.
//


import UIKit
import AVKit

protocol CircularViewControllerDelegate: AnyObject {
    func countrySelected(_ countryName: String, context: PresentationContext)
}

class CircularViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate {
    var presentationContext: PresentationContext = .fromFirstVC 
    weak var delegate: CircularViewControllerDelegate?
    var selectedCountryLabel: UILabel?
    
    let countries = [
        "노르웨이 / NOK", "말레이시아 / MYR", "미국 / USD", "스웨덴 / SEK", "스위스 / CHF", "영국 / GBP",
        "인도네시아 / IDR", "일본 / JPY", "중국 / CNY", "캐나다 / CAD", "홍콩 / HKD", "태국 / THB",
        "호주 / AUD", "뉴질랜드 / NZD", "싱가포르 / SGD"
    ]
    
    var filteredCountries: [String] = []
    var labels: [UILabel] = []
    var lastAngle: CGFloat = 0
    var counter: CGFloat = 0
    var currentRotationAngle: CGFloat = 0
    
    var lastText: String?
    var resultLabel: UILabel = UILabel()
    var centerLabel: UILabel!
    
    var searchBar: UISearchBar!
    var searchBarWidthConstraint: NSLayoutConstraint!
    var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBlurEffect()
        setupCloseButton()
        setupAddButton()
        setupSearchBar()
        customizeForContext()
        filteredCountries = countries
        displayCountries(filteredCountries)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func customizeForContext() {
        switch presentationContext {
        case .fromFirstVC:
            addButton.setTitle("변경하기", for: .normal)
        case .fromSecondVCCell:
            addButton.setTitle("변경하기", for: .normal)
        case .fromSecondVCAddButton:
            addButton.setTitle("추가하기", for: .normal)
        }
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        self.view.addSubview(blurEffectView)
    }
    
    private func setupCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.frame = CGRect(x: -30, y: 55, width: 100, height: 50)
        self.view.addSubview(closeButton)
    }
    
    private func setupAddButton() {
        addButton = UIButton(type: .system)
        addButton.setTitle("변경하기", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = .AddButton
        addButton.tintColor = .black
        addButton.addTarget(self, action: #selector(addCountryButtonTapped), for: .touchUpInside)
        addButton.layer.cornerRadius = 10
        self.view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -55),
            addButton.widthAnchor.constraint(equalToConstant: 350),
            addButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        
        let searchTextField = searchBar.searchTextField
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.masksToBounds = true
        searchTextField.backgroundColor = .darkGray
        searchTextField.textColor = .white
        searchTextField.leftView?.tintColor = .secondaryTextColor
        
        self.view.addSubview(searchBar)
        
        searchBar.placeholder = ""
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBarWidthConstraint = searchBar.widthAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            searchBarWidthConstraint
        ])
    }

    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addCountryButtonTapped() {
        if let countryText = selectedCountryLabel?.text {
            delegate?.countrySelected(countryText, context: presentationContext)
            dismiss(animated: true)
        }
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
        if counter > 12 {
            rotateLabels(by: -1)
            AudioServicesPlaySystemSound(1104)
        } else if counter < -12 {
            rotateLabels(by: 1)
            AudioServicesPlaySystemSound(1104)
        }
        if abs(counter) > 12 { counter = 0 }
        if gesture.state == .ended {
            counter = 0
            updateCheckmark()
        }
    }
    
    func rotateLabels(by steps: Int) {
        let angleStep = 2 * CGFloat.pi / CGFloat(labels.count)
        currentRotationAngle += CGFloat(steps) * angleStep
        
        let circleCenter = CGPoint(x: -70, y: view.frame.height / 2 + 20)
        let circleRadiusX: CGFloat = 250
        let circleRadiusY: CGFloat = 320
        
        UIView.animate(withDuration: 0.2, animations: {
            for (index, label) in self.labels.enumerated() {
                let baseAngle = 2 * CGFloat.pi * CGFloat(index) / CGFloat(self.labels.count) + self.currentRotationAngle
                let labelX = circleCenter.x + circleRadiusX * cos(baseAngle)
                let labelY = circleCenter.y + circleRadiusY * sin(baseAngle)
                
                label.center = CGPoint(x: labelX, y: labelY)
                label.transform = CGAffineTransform(rotationAngle: baseAngle)
            }
        }, completion: { _ in
            self.labelTextSending()
            self.updateCheckmark()
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
            selectedCountryLabel = focusedLabel // 현재 선택된 라벨 저장
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
    
    func calculateLabelSize(for text: String, font: UIFont) -> CGSize {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size
    }
    
    func displayCountries(_ countries: [String]) {
        for label in labels {
            label.removeFromSuperview()
        }
        labels.removeAll()
        
        let circleCenter = CGPoint(x: -70, y: view.frame.height / 2 + 20)
        let circleRadiusX: CGFloat = 250
        let circleRadiusY: CGFloat = 320
        
        let extendedCountries = countries + countries
        
        for (index, country) in extendedCountries.enumerated() {
            let angle = 2 * CGFloat.pi * CGFloat(index) / CGFloat(extendedCountries.count)
            let labelX = circleCenter.x + circleRadiusX * cos(angle)
            let labelY = circleCenter.y + circleRadiusY * sin(angle)
            
            let font = UIFont(name: AppFontName.interLight, size: 17) ?? UIFont.systemFont(ofSize: 17)
            let labelSize = calculateLabelSize(for: country, font: font)
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: labelSize.width + 20, height: 20))
            label.center = CGPoint(x: labelX, y: labelY)
            label.text = country
            label.font = UIFont(name: AppFontName.interLight, size: 17) ?? UIFont.systemFont(ofSize: 17)
            label.textColor = .white
            label.textAlignment = .left
            label.attributedText = attributedString(for: country, fittingWidth: 150, in: label)
            label.transform = CGAffineTransform(rotationAngle: angle)
            
            // 탭 제스처 추가
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_:)))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tapGesture)
            
            self.labels.append(label)
            self.view.addSubview(label)
        }
    }
    
    func attributedString(for text: String, fittingWidth width: CGFloat, in label: UILabel) -> NSAttributedString {
        let font = label.font ?? UIFont.systemFont(ofSize: 16)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: 1.8
        ]
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        return attributedText
    }
    
    private func updateCheckmark() {
        for label in labels {
            label.subviews.forEach { subview in
                if let imageView = subview as? UIImageView, imageView.image == UIImage(systemName: "checkmark") {
                    imageView.removeFromSuperview()
                }
            }
        }
        
        if let selectedLabel = selectedCountryLabel {
            let checkmark = UIImageView(image: UIImage(systemName: "checkmark"))
            checkmark.tintColor = .mainColor
            checkmark.translatesAutoresizingMaskIntoConstraints = false
            selectedLabel.addSubview(checkmark)
            
            NSLayoutConstraint.activate([
                checkmark.leadingAnchor.constraint(equalTo: selectedLabel.trailingAnchor, constant: 5),
                checkmark.centerYAnchor.constraint(equalTo: selectedLabel.centerYAnchor)
            ])
            
            checkmark.transform = CGAffineTransform(translationX: -30, y: 0).scaledBy(x: 0.3, y: 0.3)
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                checkmark.transform = .identity
            }, completion: nil)
        }
    }
    
    @objc func handleLabelTap(_ gesture: UITapGestureRecognizer) {
        guard let tappedLabel = gesture.view as? UILabel else { return }
        
        selectedCountryLabel = tappedLabel
        updateCheckmark()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCountries(for: searchText)
    }
    
    // UISearchBarDelegate methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // 포커스가 가면 직사각형 모양으로 펼쳐지는 애니메이션
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.searchBarWidthConstraint.constant = self.view.frame.size.width - 60
            self.view.layoutIfNeeded()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // 포커스가 가지 않으면 정사각형 모양으로 되돌리는 애니메이션
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut) {
            self.searchBarWidthConstraint.constant = 50
            self.view.layoutIfNeeded()
            searchBar.text = nil
        }
    }
}
