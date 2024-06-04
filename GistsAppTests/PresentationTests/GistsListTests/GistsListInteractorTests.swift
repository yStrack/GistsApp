//
//  GistsListInteractorTests.swift
//  GistsAppTests
//
//  Created by Yuri Marques Strack on 03/06/24.
//

import XCTest
@testable import GistsApp

final class GistsListInteractorTests: XCTestCase {

    var interactor: GistsListInteractorInput!
    var output = MockInteractorOutput()
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
        
        // Interactor to test
        let interactor = GistsListInteractor(repository: repository)
        
        // Mock output
        interactor.output = self.output
        
        self.interactor = interactor
    }

    override func tearDownWithError() throws {
        self.url = nil
        self.interactor = nil
    }

    func testSuccessGetGists() throws {
        self.setupMockNetworkRequestHandler(for: url, statusCode: 200, data: gistResponseMockData)
        let expectation = XCTestExpectation(description: "Get a list of gists.")
        output.expectation = expectation
        let page = 1
        interactor.getGistsList(for: page)
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFailToGetGists() throws {
        self.setupMockNetworkRequestHandler(for: url, statusCode: 400)
        let expectation = XCTestExpectation(description: "Fail to get a list of gists.")
        output.expectation = expectation
        let page = 1
        interactor.getGistsList(for: page)
        wait(for: [expectation], timeout: 10.0)
    }
}

final class MockInteractorOutput: GistsListInteractorOutput {
    
    var expectation: XCTestExpectation?
    
    func gistsListFound(_ gists: [GistsApp.Gist]) {
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
    
    func gistsListFailed(with error: any Error) {
        guard let error = error as? NetworkService.NetworkError else {
            XCTFail("Incorrect error received.")
            expectation?.fulfill()
            return
        }
        
        XCTAssertEqual(error, NetworkService.NetworkError.unexpectedStatusCode, "Expected get gists to fail.")
        expectation?.fulfill()
    }
}
