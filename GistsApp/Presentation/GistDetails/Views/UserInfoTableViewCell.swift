//
//  UserInfoTableViewCell.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 03/06/24.
//

import UIKit
import Kingfisher

class UserInfoTableViewCell: UITableViewCell {
    
    public static let identifier: String = "UserInfoTableViewCell"

    // MARK: Views
    private lazy var userInfoHorizontalStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 64 / 2
        imageView.layer.borderColor = UIColor.red.cgColor
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        userInfoHorizontalStackView.addArrangedSubview(avatarImageView)
        userInfoHorizontalStackView.addArrangedSubview(usernameLabel)
        contentView.addSubview(userInfoHorizontalStackView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 64),
            avatarImageView.widthAnchor.constraint(equalToConstant: 64),
            
            userInfoHorizontalStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            userInfoHorizontalStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            userInfoHorizontalStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            userInfoHorizontalStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    public func setup(imageURL: URL?, name: String) {
        avatarImageView.kf.setImage(with: imageURL)
        usernameLabel.text = name
    }
}
