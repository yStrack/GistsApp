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
    
    public static let identifier: String = "LoadMoreFooterView"
    
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
    
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        indicator.color = .systemBackground
        return indicator
    }()
    
    // MARK: Initializer
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        contentView.addSubview(loadingIndicatorView)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            loadingIndicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Action
    @objc private func didTapLoadMore() {
        loadingIndicatorView.startAnimating()
        button.setTitleColor(.clear, for: .normal)
        delegate?.didTapLoadMore()
    }
    
    public func finishLoading() {
        loadingIndicatorView.stopAnimating()
        button.setTitleColor(.systemBackground, for: .normal)
    }
}
