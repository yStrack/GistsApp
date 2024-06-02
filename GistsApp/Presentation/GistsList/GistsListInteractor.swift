//
//  GistsListInteractor.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 02/06/24.
//

import Foundation

protocol GistsListInteractorInput {
    func getGistsList(for page: Int)
}

protocol GistsListInteractorOutput {
    func gistsListFound(_ gists: [Gist])
    func gistsListFailed(with error: Error)
}

final class GistsListInteractor: GistsListInteractorInput {
    
    // MARK: Dependencies
    let repository: GistsRepositoryInterface
    var output: GistsListInteractorOutput?
    
    // MARK: Initializer
    init(repository: GistsRepositoryInterface) {
        self.repository = repository
    }
    
    // MARK: Input functions
    func getGistsList(for page: Int) {
        repository.getGists(page: page) { result in
            switch result {
            case .success(let gists):
                self.output?.gistsListFound(gists)
            case .failure(let error):
                self.output?.gistsListFailed(with: error)
            }
        }
    }
}
