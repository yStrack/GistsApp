//
//  File.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 29/05/24.
//

import Foundation

struct File: Hashable {
    let name: String
}

extension File {
    init?(from fileResponse: FileResponse) {
        guard let filename = fileResponse.filename else { return nil }
        self.name = filename
    }
}
