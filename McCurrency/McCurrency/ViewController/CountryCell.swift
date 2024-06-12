//
//  CountryCell.swift
//  McCurrency
//
//  Created by 임재현 on 6/5/24.
//

import UIKit


protocol CountryCellDelegate: AnyObject {
    func buttonTapped(_ cell: CountryCell)
}

 
class CountryCell: UITableViewCell {
 
    weak var delegate: CountryCellDelegate?
    var indexPath: IndexPath?

    static let cellId = "CountryCellId"
    let stackView = UIStackView()
    let hamburgerImage = UIImageView()
    let countLabel = UILabel()
    
    
    let toCountryButton = UIButton()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()


        backgroundColor = .backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        
        
        toCountryButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(toCountryButton)
        toCountryButton.addTarget(self, action: #selector(toCountryButtonTapped), for: .touchUpInside)
        
        self.selectionStyle = .none
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.backgroundColor = .red
        
        toCountryButton.backgroundColor = .boxColor
        countLabel.font = UIFont.systemFont(ofSize: 30)
        countLabel.textColor = .white
        
        
        
        hamburgerImage.contentMode = .scaleAspectFit
        hamburgerImage.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(hamburgerImage)
        
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(countLabel)
        
        
        NSLayoutConstraint.activate([
            toCountryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            toCountryButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toCountryButton.widthAnchor.constraint(equalToConstant: 100),
            toCountryButton.heightAnchor.constraint(equalToConstant: 32),
            
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            hamburgerImage.widthAnchor.constraint(equalToConstant: 28),
            hamburgerImage.heightAnchor.constraint(equalToConstant: 28),
            
            countLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
    
    @objc func toCountryButtonTapped() {
            delegate?.buttonTapped(self)
        }
}
//
//extension CountryCell:CountryCellDelegate {
//    func buttonTapped(in cell: CountryCell) {
//        self.delegate?.buttonTapped(in: self)
//    }
//    
//    
//}
