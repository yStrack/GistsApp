//
//  Endpoint+Protocol.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 28/05/24.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: String]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension Endpoint {
    func url() -> URL? {
        var urlComponents = URLComponents(string: self.baseURL)
        urlComponents?.path = self.path
        
        var queryItems: [URLQueryItem] = []
        self.parameters?.forEach({ key, value in
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        })
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
    }
}
