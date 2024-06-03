//
//  LoadMoreFooterView.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 03/06/24.
//

import UIKit

protocol LoadMoreButtonDelegate {
    func didTapLoadMore()
}

final class LoadMoreFooterView: UITableViewHeaderFooterView {
    
    static let identifier: String = "LoadMoreFooterView"
    
    var delegate: LoadMoreButtonDelegate?
    
    // MARK: Views
    private lazy var button: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Carregar mais", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.addTarget(self, action: #selector(didTapLoadMore), for: .touchUpInside)
        return button
    }()
    
    // MARK: Initializer
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Action
    @objc private func didTapLoadMore() {
        delegate?.didTapLoadMore()
    }
}
