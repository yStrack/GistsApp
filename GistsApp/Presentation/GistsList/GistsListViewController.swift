//
//  GistsListViewController.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 02/06/24.
//

import UIKit

final class GistsListViewController: UIViewController {
    
    // MARK: TableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GistsListTableViewCell.self, forCellReuseIdentifier: GistsListTableViewCell.identifier)
        tableView.register(LoadMoreFooterView.self, forHeaderFooterViewReuseIdentifier: LoadMoreFooterView.identifier)
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, Gist.ID> = {
        return UITableViewDiffableDataSource<Int, Gist.ID>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard 
                let cell = tableView.dequeueReusableCell(withIdentifier: GistsListTableViewCell.identifier, for: indexPath) as? GistsListTableViewCell
            else {
                return nil
            }
            
            let gist = self.presenter.getGist(at: indexPath.row)
            cell.setup(with: gist)
            
            return cell
        }
    }()
    
    // MARK: Views
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.startAnimating()
        indicator.color = .systemBlue
        return indicator
    }()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    // MARK: Dependencies
    let presenter: GistsListPresenterInput
    
    // MARK: Initializers
    init(presenter: GistsListPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gists"
        presenter.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(loadingIndicatorView)
        view.addSubview(errorView)
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: Setup subviews
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            loadingIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: Presenter output implementation
extension GistsListViewController: GistsListPresenterOutput {
    func didFoundGistsList(_ gists: [Gist]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Gist.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(gists.map({ $0.id }), toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func updateGistsList(_ newGists: [Gist]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(newGists.map({ $0.id }), toSection: 0)
        dataSource.apply(snapshot)
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.loadingIndicatorView.startAnimating()
            self.tableView.isScrollEnabled = false
            self.errorView.isHidden = true
        }
    }
    
    func hideLoading(withError: Bool) {
        DispatchQueue.main.async {
            self.loadingIndicatorView.stopAnimating()
            if withError {
                self.tableView.isScrollEnabled = false
                self.errorView.isHidden = false
                return
            }
            self.tableView.isScrollEnabled = true
            self.errorView.isHidden = true
        }
    }
}

// MARK: UITableViewDelegate
extension GistsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectedGist(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: LoadMoreFooterView.identifier) as? LoadMoreFooterView
        cell?.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? GistsListTableViewCell else { return }
        cell.avatarImageView.kf.cancelDownloadTask()
    }
}

// MARK: ErrorViewDelegate
extension GistsListViewController: ErrorViewDelegate {
    func didTapRetryButton() {
        presenter.retryButtonTap()
    }
}

// MARK: LoadMoreButtonDelegate
extension GistsListViewController: LoadMoreButtonDelegate {
    func didTapLoadMore() {
        presenter.loadMoreGists()
    }
}
