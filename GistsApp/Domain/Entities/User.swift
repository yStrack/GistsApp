//
//  User.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 29/05/24.
//

import Foundation

struct User: Identifiable, Hashable {
    let id: Int
    let name: String
    let avatarURL: URL
}

extension User {
    init?(from userResponse: UserResponse) {
        guard
            let id = userResponse.id,
            let name = userResponse.login,
            let avatarURLString = userResponse.avatarURL,
            let avatarURL = URL(string: avatarURLString)
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
    }
}
