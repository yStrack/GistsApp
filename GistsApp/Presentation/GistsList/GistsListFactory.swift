//
//  GistsListFactory.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 02/06/24.
//

import Foundation
import UIKit

protocol SceneFactory {
    associatedtype Dependencies
    static func make(with dependencies: Dependencies?) -> UIViewController
}

enum GistsListFactory: SceneFactory {
    struct Dependencies {}
    
    static func make(with dependencies: Dependencies? = nil) -> UIViewController {
        let service = NetworkService()
        let repository = GistsAPIRepository(service: service)
        let interactor = GistsListInteractor(repository: repository)
        let router = GistsListRouter()
        let presenter = GistsListPresenter(interactor: interactor, router: router)
        interactor.output = presenter
        
        let viewController = GistsListViewController(presenter: presenter)
        router.viewController = viewController
        presenter.output = viewController
        
        return viewController
    }
}
