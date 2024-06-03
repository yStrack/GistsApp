//
//  ErrorView.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 02/06/24.
//

import UIKit

protocol ErrorViewDelegate {
    func didTapRetryButton()
}

final class ErrorView: UIView {
    
    // MARK: Views
    private lazy var errorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Ocorreu um erro inesperado"
        return label
    }()
    
    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "exclamationmark.triangle")
        imageView.tintColor = .label
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .largeTitle))
        return imageView
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Tentar novamente", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(retryButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: Dependencies
    var delegate: ErrorViewDelegate?
    
    // MARK: Initializer
    init() {
        super.init(frame: .zero)
        verticalStackView.addArrangedSubview(errorImageView)
        verticalStackView.addArrangedSubview(errorLabel)
        verticalStackView.addArrangedSubview(retryButton)
        addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func retryButtonAction() {
        delegate?.didTapRetryButton()
    }
}
