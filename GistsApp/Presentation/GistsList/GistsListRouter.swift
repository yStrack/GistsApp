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
    func routeToGistDetails(_ gist: Gist)
}

final class GistsListRouter: GistsListRouterProtocol {
    weak var viewController: UIViewController?
    
    func routeToGistDetails(_ gist: Gist) {
        let detailsVC = GistDetailsViewController(gist: gist)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
