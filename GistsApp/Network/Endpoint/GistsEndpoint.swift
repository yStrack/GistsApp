//
//  GistsEndpoint.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 28/05/24.
//

import Foundation

enum GistsEndpoint: Endpoint {
    case publicList(page: Int)
    
    var baseURL: String {
        return "https://api.github.com"
    }
    
    var path: String {
        return "/gists/public"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        return [
            "Accept": "application/vnd.github+json"
        ]
    }
    
    var parameters: [String : String]? {
        switch self {
        case .publicList(let page):
            return [
                "page": "\(page)"
            ]
        }
    }
}
