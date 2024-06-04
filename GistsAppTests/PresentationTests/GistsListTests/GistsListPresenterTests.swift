//
//  GistsListPresenterTests.swift
//  GistsAppTests
//
//  Created by Yuri Marques Strack on 03/06/24.
//

import XCTest
@testable import GistsApp

final class GistsListPresenterTests: XCTestCase {
    
    var presenter: GistsListPresenterInput!
    var output = MockPresenterOutput()
    let viewController = UINavigationController(rootViewController: UIViewController())
    var url: URL!

    override func setUpWithError() throws {
        // Mock service
        self.url = GistsEndpoint.publicList(page: 1).url()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        let service = NetworkService(urlSession: urlSession)
        
        // Mock repository
        let repository = GistsAPIRepository(service: service)
        
        // Mock Interactor
        let interactor = GistsListInteractor(repository: repository)
        
        // Mock Router
        let router = GistsListRouter()
        
        // Presenter to test
        let presenter = GistsListPresenter(interactor: interactor, router: router)
        interactor.output = presenter
        presenter.output = self.output
        
        self.presenter = presenter
    }

    override func tearDownWithError() throws {
        self.url = nil
        self.presenter = nil
    }

    func testViewDidLoad() throws {
        self.setupMockNetworkRequestHandler(for: url, statusCode: 200, data: gistResponseMockData)
        let expectation = XCTestExpectation(description: "Fetch Git list on viewDidLoad.")
        let loadingExpectation = XCTestExpectation(description: "Hide loading without error.")
        output.expectation = expectation
        output.loadingExpectation = loadingExpectation
        presenter.viewDidLoad()
        wait(for: [expectation, loadingExpectation], timeout: 10.0)
    }
    
    func testLoadMore() throws {
        self.url = GistsEndpoint.publicList(page: 2).url()
        self.setupMockNetworkRequestHandler(for: url, statusCode: 200, data: gistResponseMockData)
        let expectation = XCTestExpectation(description: "New gists list.")
        output.expectation = expectation
        presenter.loadMoreGists()
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testError() throws {
        self.setupMockNetworkRequestHandler(for: url, statusCode: 200, data: gistResponseMissingOwnerMockData)
        let expectation = XCTestExpectation(description: "Empty gists list.")
        let loadingExpectation = XCTestExpectation(description: "Hide loading with error.")
        output.expectation = expectation
        output.loadingExpectation = loadingExpectation
        presenter.viewDidLoad()
        wait(for: [expectation, loadingExpectation], timeout: 10.0)
    }
    
    func testRetryButton() throws {
        self.setupMockNetworkRequestHandler(for: url, statusCode: 200, data: gistResponseMockData)
        let expectation = XCTestExpectation(description: "Fetch first page gists.")
        let loadingExpectation = XCTestExpectation(description: "Hide loading without error.")
        output.expectation = expectation
        output.loadingExpectation = loadingExpectation
        presenter.retryButtonTap()
        wait(for: [expectation, loadingExpectation], timeout: 10.0)
    }
}

final class MockPresenterOutput: GistsListPresenterOutput {
    
    var expectation: XCTestExpectation?
    var loadingExpectation: XCTestExpectation?
    var didFail: Bool = false
    
    func didFoundGistsList(_ gists: [GistsApp.Gist]) {
        if didFail {
            XCTAssertTrue(gists.isEmpty, "Gists list must be empty when something fails.")
            expectation?.fulfill()
            return
        }
        
        guard
            !gists.isEmpty,
            let gist = gists.first
        else {
            XCTFail("Expected non empty gists list.")
            expectation?.fulfill()
            return
        }
        XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d", "Incorrect gist ID.")
        XCTAssertEqual(gist.owner.name, "octocat", "Incorrect gist owner name.")
        XCTAssertEqual(gist.files.count, 1, "Incorrect gist files number.")
        expectation?.fulfill()
    }
    
    func updateGistsList(_ newGists: [GistsApp.Gist]) {
        guard
            !newGists.isEmpty,
            let gist = newGists.first
        else {
            XCTFail("Expected non empty gists list.")
            expectation?.fulfill()
            return
        }
        XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d", "Incorrect gist ID.")
        XCTAssertEqual(gist.owner.name, "octocat", "Incorrect gist owner name.")
        XCTAssertEqual(gist.files.count, 1, "Incorrect gist files number.")
        expectation?.fulfill()
    }
    
    func showLoading() {
        loadingExpectation?.fulfill()
    }
    
    func hideLoading(withError: Bool) {
        didFail = withError
        loadingExpectation?.fulfill()
    }
}
