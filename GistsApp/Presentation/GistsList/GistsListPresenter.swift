//
//  GistsListPresenter.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 02/06/24.
//

import Foundation

protocol GistsListPresenterInput {
    func viewDidLoad()
    func getGist(at index: Int) -> Gist
    func loadMoreGists()
    func didSelectedGist(at index: Int)
    func retryButtonTap()
}

protocol GistsListPresenterOutput {
    func updateGistsList(_ gists: [Gist])
    func showLoading()
    func hideLoading(withError: Bool)
}

final class GistsListPresenter: GistsListPresenterInput {
    
    private var currentPage: Int = 0
    private var gists: [Gist] = []
    
    // MARK: Dependencies
    let interactor: GistsListInteractorInput
    let router: GistsListRouterProtocol
    var output: GistsListPresenterOutput?
    
    // MARK: Initializer
    init(interactor: GistsListInteractorInput, router: GistsListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: Input functions
    func viewDidLoad() {
        interactor.getGistsList(for: currentPage)
    }
    
    func getGist(at index: Int) -> Gist {
        return gists[index]
    }
    
    func loadMoreGists() {
        currentPage += 1
        interactor.getGistsList(for: currentPage)
    }
    
    func didSelectedGist(at index: Int) {
        router.routeToGistDetails()
    }
    
    func retryButtonTap() {
        output?.showLoading()
        currentPage = 0
        interactor.getGistsList(for: currentPage)
    }
}

// MARK: Interactor output implmentation
extension GistsListPresenter: GistsListInteractorOutput {
    func gistsListFound(_ gists: [Gist]) {
        self.gists.append(contentsOf: gists)
        output?.hideLoading(withError: false)
        output?.updateGistsList(gists)
    }
    
    func gistsListFailed(with error: any Error) {
        output?.hideLoading(withError: true)
    }
}
