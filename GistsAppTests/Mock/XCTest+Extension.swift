//
//  XCTest+Extension.swift
//  GistsAppTests
//
//  Created by Yuri Marques Strack on 30/05/24.
//

import Foundation
import XCTest
@testable import GistsApp

extension XCTest {
    func setupMockNetworkRequestHandler(for url: URL, statusCode: Int, data: Data? = nil) {
        MockURLProtocol.requestHandler = { request in
            guard
                let requestURL = request.url,
                requestURL == url
            else {
                throw NetworkService.NetworkError.invalidEndpoint
            }
            guard
                let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
            else {
                throw NetworkService.NetworkError.unknown
            }
            
            return (response, data)
        }
    }
}
