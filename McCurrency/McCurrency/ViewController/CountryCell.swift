//
//  CountryCell.swift
//  McCurrency
//
//  Created by 임재현 on 6/5/24.
//

import UIKit

protocol CountryCellDelegate: AnyObject {
    func countryViewDidTap(_ cell: CountryCell)
}
 
class CountryCell: UITableViewCell {
   
    weak var delegate: CountryCellDelegate?

    
    static let cellId = "CountryCellId"
    let stackView = UIStackView()
    let countryView = CountryFlagView()
    let hamburgerImage = UIImageView()
    let countLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupTapGesture()

        backgroundColor = .backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        countryView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countryView)
        
        self.selectionStyle = .none
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        countryView.backgroundColor = .lightGray
        countLabel.font = UIFont.systemFont(ofSize: 30)
        countLabel.textColor = .white
        
        
        
        hamburgerImage.contentMode = .scaleAspectFit
        hamburgerImage.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(hamburgerImage)
        
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(countLabel)
        
        
        NSLayoutConstraint.activate([
            countryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            countryView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countryView.widthAnchor.constraint(equalToConstant: 95),
            countryView.heightAnchor.constraint(equalToConstant: 32),
            
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            hamburgerImage.widthAnchor.constraint(equalToConstant: 28),
            hamburgerImage.heightAnchor.constraint(equalToConstant: 28),
            
            countLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)  
        ])
    }
    
    
    private func setupTapGesture() {
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(countryViewTapped))
           countryView.isUserInteractionEnabled = true
           countryView.addGestureRecognizer(tapGesture)
       }
    
    @objc func countryViewTapped() {
            delegate?.countryViewDidTap(self)
        }
    
    
}
