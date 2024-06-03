//
//  GistsListPresenter.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 02/06/24.
//

import Foundation

protocol GistsListPresenterInput {
    func viewDidLoad()
    func loadMoreGists()
    func didSelectedGist(at index: Int)
    func retryButtonTap()
}

protocol GistsListPresenterOutput {
    func didFoundGistsList(_ gists: [Gist])
    func updateGistsList(_ newGists: [Gist])
    func showLoading()
    func hideLoading(withError: Bool)
}

final class GistsListPresenter: GistsListPresenterInput {
    
    private var currentPage: Int = 1
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
    
    func loadMoreGists() {
        currentPage += 1
        interactor.getGistsList(for: currentPage)
    }
    
    func didSelectedGist(at index: Int) {
        router.routeToGistDetails()
    }
    
    func retryButtonTap() {
        output?.showLoading()
        currentPage = 1
        interactor.getGistsList(for: currentPage)
    }
}

// MARK: Interactor output implmentation
extension GistsListPresenter: GistsListInteractorOutput {
    func gistsListFound(_ gists: [Gist]) {
        // Append new content.
        self.gists.append(contentsOf: gists)
        // Fresh gist list.
        if currentPage == 1 {
            output?.hideLoading(withError: gists.isEmpty ? true : false)
            output?.didFoundGistsList(self.gists)
            return
        }
        // Loaded more gists.
        output?.updateGistsList(gists)
    }
    
    func gistsListFailed(with error: any Error) {
        // Only show error on fresh content.
        guard currentPage == 1 else {
            return
        }
        output?.hideLoading(withError: true)
    }
}
