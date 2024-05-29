//
//  NetworkService.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 28/05/24.
//

import Foundation

// MARK: Netwtork Protocol
protocol NetworkServiceProtocol {
    /// Send a network request for the given endpoint.
    func sendRequest<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void)
}

// MARK: Network Implementation
class NetworkService: NetworkServiceProtocol {
    
    // MARK: Dependencies
    private let urlSession: URLSession
    
    // MARK: Initializer
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func sendRequest<T>(endpoint: any Endpoint, completion: @escaping (Result<T, any Error>) -> Void) where T : Decodable {
        do {
            let request = try self.createURLRequest(endpoint: endpoint)
            
            urlSession.dataTask(with: request) { data, response, error in
                if let error {
                    completion(.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                    completion(.failure(NetworkError.unexpectedStatusCode))
                    return
                }
                
                guard let data, let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    completion(.failure(NetworkError.unableToParse))
                    return
                }
                
                completion(.success(decodedResponse))
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    /// Create the URLRequest object using received Endpoint information.
    /// - Parameter endpoint: Endpoint data.
    /// - Returns: URLRequest.
    private func createURLRequest(endpoint: Endpoint) throws -> URLRequest {
        guard let url = endpoint.url() else { throw NetworkError.invalidEndpoint }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        return request
    }
    
    /// Network layer Errors.
    public enum NetworkError: Error {
        /// Failed to build endpoint URL.
        case invalidEndpoint
        /// API responded with a failure status code (Outside range 200...299).
        case unexpectedStatusCode
        /// Failed to decode response Data.
        case unableToParse
        /// Something unknown went wrong while fetching API data.
        case unknown
    }
}
