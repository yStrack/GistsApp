//
//  GistsRepositoryTests.swift
//  GistsAppTests
//
//  Created by Yuri Marques Strack on 29/05/24.
//

import XCTest
@testable import GistsApp

final class GistsRepositoryTests: XCTestCase {
    
    var repository: GistsRepositoryInterface!
    var expectation: XCTestExpectation!
    var url: URL!
    
    override func setUpWithError() throws {
        // Mock service
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        let service = NetworkService(urlSession: urlSession)
        // Setup
        self.repository = GistsAPIRepository(service: service)
        self.expectation = XCTestExpectation(description: "Fetch Gists list from Github API.")
        self.url = GistsEndpoint.publicList(page: 0).url()
    }

    override func tearDownWithError() throws {
        repository = nil
    }

    func testSuccessGetGists() throws {
        self.setupNetworkRequestHandler(statusCode: 200, data: gistResponseMockData)
        
        repository.getGists(page: 0) { result in
            switch result {
            case .success(let gists):
                guard
                    !gists.isEmpty,
                    let gist = gists.first
                else {
                    XCTFail("Expected non empty gists list.")
                    return
                }
                
                XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d", "Incorrect gist ID.")
                XCTAssertEqual(gist.owner.name, "octocat", "Incorrect gist owner name.")
                XCTAssertEqual(gist.files.count, 1, "Incorrect gist files number.")
            case .failure(let error):
                XCTFail("Get Gists should not fail, failed with \(error.localizedDescription).")
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    func testEmptyGists() throws {
        self.setupNetworkRequestHandler(statusCode: 200, data: gistResponseMissingOwnerMockData)
        
        repository.getGists(page: 0) { result in
            switch result {
            case .success(let gists):
                XCTAssertTrue(gists.isEmpty, "Expected empty gists list.")
            case .failure(let error):
                XCTFail("Get Gists should not fail, failed with \(error.localizedDescription)")
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    func testFailToGetGists() throws {
        self.setupNetworkRequestHandler(statusCode: 400)
        
        repository.getGists(page: 0) { result in
            switch result {
            case .success(_):
                XCTFail("Success response was not expected.")
            case .failure(let error):
                guard let error = error as? NetworkService.NetworkError else {
                    XCTFail("Incorrect error received.")
                    self.expectation.fulfill()
                    return
                }
                
                XCTAssertEqual(error, NetworkService.NetworkError.unexpectedStatusCode, "Expected get gists to fail.")
            }
        }
    }
    
    private func setupNetworkRequestHandler(statusCode: Int, data: Data? = nil) {
        MockURLProtocol.requestHandler = { request in
            guard
                let response = HTTPURLResponse(url: self.url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
            else {
                throw NetworkService.NetworkError.unknown
            }
            
            return (response, data)
        }
    }
}
