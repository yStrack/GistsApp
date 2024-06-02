//
//  GistsListTableViewCell.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 02/06/24.
//

import UIKit
import Kingfisher

class GistsListTableViewCell: UITableViewCell {
    
    public static let identifier: String = "GistsListTableViewCell"
    
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
        imageView.layer.cornerRadius = 24 / 2
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var contentVerticalStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var filenameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var createdAtLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private lazy var filesAndCommentsHorizontalStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var filesImage: UIImageView = UIImageView(image: UIImage(systemName: "doc"))
    private lazy var numberOfFilesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private lazy var commentsImage: UIImageView = UIImageView(image: UIImage(systemName: "bubble.left"))
    private lazy var numberOfCommentsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: Setup functions
    public func setup(with gist: Gist) {
        avatarImageView.kf.setImage(with: gist.owner.avatarURL)
        usernameLabel.text = gist.owner.name
        filenameLabel.text = gist.files.first?.name
        descriptionLabel.text = gist.description
        let timeElapsed: Int = Int(gist.createdAt.distance(to: Date()) / 60)
        createdAtLabel.text = timeElapsed < 1 ? "Criado agora" : "Criado \(timeElapsed) minuto\(timeElapsed > 1 ? "s" : "") atrás"
        numberOfFilesLabel.text = "\(gist.files.count) arquivo\(gist.files.count > 1 ? "s" : "")"
        numberOfCommentsLabel.text = "\(gist.comments) comentário\(gist.comments == 1 ? "" : "s")"
        filesImage.tintColor = .label
        commentsImage.tintColor = .label
    }
    
    private func addSubviews() {
        // User info horizontal Stack View
        userInfoHorizontalStackView.addArrangedSubview(avatarImageView)
        userInfoHorizontalStackView.addArrangedSubview(usernameLabel)
        // Files and Comments horizontal Stack View
        filesAndCommentsHorizontalStackView.addArrangedSubview(filesImage)
        filesAndCommentsHorizontalStackView.addArrangedSubview(numberOfFilesLabel)
        filesAndCommentsHorizontalStackView.addArrangedSubview(commentsImage)
        filesAndCommentsHorizontalStackView.addArrangedSubview(numberOfCommentsLabel)
        // Vertical Stack View
        contentVerticalStackView.addArrangedSubview(userInfoHorizontalStackView)
        contentVerticalStackView.addArrangedSubview(filenameLabel)
        contentVerticalStackView.addArrangedSubview(descriptionLabel)
        contentVerticalStackView.addArrangedSubview(createdAtLabel)
        contentVerticalStackView.addArrangedSubview(filesAndCommentsHorizontalStackView)
        contentView.addSubview(contentVerticalStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 24),
            avatarImageView.widthAnchor.constraint(equalToConstant: 24),
            contentVerticalStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            contentVerticalStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            contentVerticalStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            contentVerticalStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }
}
