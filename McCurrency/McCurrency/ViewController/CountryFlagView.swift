//
//  CountryFlagView.swift
//  McCurrency
//
//  Created by 조아라 on 6/10/24.
//

import UIKit


//class CountryFlagView: UIView {
//    private let flagImageView = UIImageView()
//    private let nameButton = UIButton()
//    
//    var delegate: CountryFlagViewDelegate?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//        setupConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupViews() {
//        flagImageView.contentMode = .scaleAspectFit
//        addSubview(flagImageView)
//
//        nameButton.configuration = .plain()
//        nameButton.backgroundColor = .boxColor
//        nameButton.layer.cornerRadius = 5
//        nameButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        nameButton.setTitleColor(.white, for: .normal)
//        nameButton.addTarget(self, action: #selector(callCircularViewModal), for: .touchUpInside)
//        addSubview(nameButton)
//    }
//    
//    @objc func callCircularViewModal() {
//        self.delegate?.openCircularMenuView()
//    }
//
//    private func setupConstraints() {
//        flagImageView.translatesAutoresizingMaskIntoConstraints = false
//        nameButton.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//           // flagImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
////            flagImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
////            flagImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
////            flagImageView.widthAnchor.constraint(equalToConstant: 25),
////            flagImageView.heightAnchor.constraint(equalToConstant: 25),
//
//            nameButton.leadingAnchor.constraint(equalTo:,
//            nameButton.trailingAnchor.constraint(equalTo: trailingAnchor),
//            nameButton.centerYAnchor.constraint(equalTo: centerYAnchor),
//            nameButton.widthAnchor.constraint(equalToConstant: 100),
//            nameButton.heightAnchor.constraint(equalToConstant: 32)
//        ])
//    }
//
//    func configure(with countryName: String, imageName: String) {
//        nameButton.configuration?.title = countryName
//        flagImageView.image = UIImage(systemName: imageName)
//    }
//}

