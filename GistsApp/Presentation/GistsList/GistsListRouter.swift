//
//  GistsListRouter.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 02/06/24.
//

import Foundation
import UIKit

protocol GistsListRouterProtocol {
    var viewController: UIViewController? { get }
    func routeToGistDetails()
}

final class GistsListRouter: GistsListRouterProtocol {
    weak var viewController: UIViewController?
    
    func routeToGistDetails() {
        let detailsVC = UIViewController()
        detailsVC.view.backgroundColor = .systemGroupedBackground
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
