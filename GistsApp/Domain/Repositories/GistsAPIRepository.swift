//
//  GistsAPIRepository.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 29/05/24.
//

import Foundation

final class GistsAPIRepository: GistsRepositoryInterface {
    
    let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        self.service = service
    }
    
    func getGists(page: Int, completion: @escaping (Result<[Gist],Error>) -> Void) {
        let endpoint = GistsEndpoint.publicList(page: page)
        
        service.sendRequest(endpoint: endpoint) { (result: Result<[GistResponse], Error>) in
            switch result {
            case .success(let response):
                // Map network layer gists model to domain model.
                let gists = response.compactMap({ Gist(from: $0) })
                completion(.success(gists))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
