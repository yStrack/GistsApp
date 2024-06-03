//
//  Gist.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 29/05/24.
//

import Foundation

struct Gist: Identifiable, Hashable {
    let id: String
    let createdAt: Date
    let comments: Int
    let description: String?
    let owner: User
    let files: [File]
}

extension Gist {
    init?(from gistResponse: GistResponse) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        
        guard
            let id = gistResponse.id,
            let createdAt = gistResponse.createdAt,
            let date = dateFormatter.date(from: createdAt),
            let ownerResponse = gistResponse.owner,
            let owner = User(from: ownerResponse)
        else {
            return nil
        }
        
        self.id = id
        self.createdAt = date
        self.comments = gistResponse.comments ?? 0
        self.description = gistResponse.description
        self.owner = owner
        self.files = gistResponse.files.values.compactMap({ File(from: $0) })
    }
}
