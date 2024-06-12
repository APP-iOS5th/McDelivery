//
//  CountryFlagView.swift
//  McCurrency
//
//  Created by 임재현 on 6/4/24.
//

import UIKit


class CountryFlagView: UIView {
    private let flagImageView = UIImageView()
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        flagImageView.contentMode = .scaleAspectFit
        addSubview(flagImageView)

        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = .white
        addSubview(nameLabel)
    }

    private func setupConstraints() {
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            flagImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            flagImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 25),
            flagImageView.heightAnchor.constraint(equalToConstant: 25),

            nameLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configure(with countryName: String, imageName: String) {
        nameLabel.text = countryName
        flagImageView.image = UIImage(systemName: imageName)
    }
}
