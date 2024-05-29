//
//  NetworkServiceTests.swift
//  GistsAppTests
//
//  Created by Yuri Marques Strack on 28/05/24.
//

import XCTest
@testable import GistsApp

final class NetworkServiceTests: XCTestCase {
    
    var service: NetworkServiceProtocol!
    var expectation: XCTestExpectation!
    let endpoint: Endpoint = GistsEndpoint.publicList(page: 0)
    var url: URL!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        service = NetworkService(urlSession: urlSession)
        expectation = XCTestExpectation(description: "Fetch Gists list from Github API.")
        url = self.endpoint.url()
    }

    override func tearDownWithError() throws {
        service = nil
        expectation = nil
    }

    func testSuccessfulResponse() throws {
        // Setup desired test response.
        MockURLProtocol.requestHandler = { [weak self] request in
            guard let self else { throw NetworkService.NetworkError.unknown }
            guard
                let url = request.url,
                url == self.url,
                let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            else {
                throw NetworkService.NetworkError.invalidEndpoint
            }
            
            return (response, gistResponseMockData)
        }
        
        service.sendRequest(endpoint: endpoint, completion: { (result: Result<[GistResponse], Error>) in
            switch result {
            case .success(let response):
                guard
                    !response.isEmpty,
                    let gist = response.first
                else {
                    XCTFail("Expected non empty gists list.")
                    return
                }
                
                XCTAssertTrue(gist.url == "https://api.github.com/gists/aa5a315d61ae9438b18d", "Incorrect gist url.")
                XCTAssertTrue(gist.files.keys.count == 1, "Incorrect number of gist files.")
                XCTAssertTrue(gist.owner?.login == "octocat", "Incorrect gist owner login.")
            case .failure(let error):
                XCTFail("Fetching Gists should not fail, failed with \(error.localizedDescription)")
            }
            
            self.expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testParsingFail() throws {
        // Setup desired test response.
        MockURLProtocol.requestHandler = { [weak self] request in
            guard let self else { throw NetworkService.NetworkError.unknown }
            guard 
                let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            else {
                throw NetworkService.NetworkError.invalidEndpoint
            }
            
            return (response, Data())
        }
        
        service.sendRequest(endpoint: endpoint) { (result: Result<[GistResponse], Error>) in
            switch result {
            case .success(_):
                XCTFail("Success response was not expected.")
            case .failure(let error):
                guard let error = error as? NetworkService.NetworkError else {
                    XCTFail("Incorrect error received.")
                    self.expectation.fulfill()
                    return
                }
                XCTAssertEqual(error, NetworkService.NetworkError.unableToParse, "Parsing error expected.")
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFailureStatusCode() throws {
        // Setup desired test response.
        MockURLProtocol.requestHandler = { [weak self] request in
            guard let self else { throw NetworkService.NetworkError.unknown }
            guard
                let response = HTTPURLResponse(url: self.url, statusCode: 400, httpVersion: nil, headerFields: nil)
            else {
                throw NetworkService.NetworkError.invalidEndpoint
            }
            
            return (response, nil)
        }
        
        service.sendRequest(endpoint: endpoint) { (result: Result<[GistResponse], Error>) in
            switch result {
            case .success(_):
                XCTFail("Success response was not expected.")
            case .failure(let error):
                guard let error = error as? NetworkService.NetworkError else {
                    XCTFail("Incorrect error received.")
                    self.expectation.fulfill()
                    return
                }
                XCTAssertEqual(error, NetworkService.NetworkError.unexpectedStatusCode, "Failure status code error expected.")
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
