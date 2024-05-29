//
//  MockURLProtocol.swift
//  GistsAppTests
//
//  Created by Yuri Marques Strack on 29/05/24.
//

import Foundation

class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Request handler unavailable.")
        }
        
        do {
            let (response, data) = try handler(request)
            // Notify client with the response.
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data {
                // Notify client with the data.
                client?.urlProtocol(self, didLoad: data)
            }
            
            // Notify client request finished.
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            // Notify client received error.
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
