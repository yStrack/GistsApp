//
//  GistDetailsViewController.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 03/06/24.
//

import UIKit

class GistDetailsViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UserInfoTableViewCell.self, forCellReuseIdentifier: UserInfoTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: Dependencies
    let gist: Gist
    
    // MARK: Initializers
    init(gist: Gist) {
        self.gist = gist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupConstraints()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: Setup
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: UITableViewDataSource
extension GistDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return gist.files.count
        default:
            fatalError("Unknown section.")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.identifier, for: indexPath) as? UserInfoTableViewCell
            else {
                fatalError("Failed to dequeueReusableCell.")
            }
            cell.setup(imageURL: gist.owner.avatarURL, name: gist.owner.name)
            return cell
        case 1:
            let cell = UITableViewCell()
            cell.imageView?.image = UIImage(systemName: "doc")
            cell.imageView?.tintColor = UIColor.label
            cell.textLabel?.text = gist.files[indexPath.row].name
            cell.selectionStyle = .none
            
            return cell
        default:
            fatalError("Unknown section.")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else { return nil }
        return "Arquivo\(gist.files.count > 1 ? "s" : "")"
    }
}
