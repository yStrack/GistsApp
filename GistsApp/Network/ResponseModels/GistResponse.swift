//
//  GistResponse.swift
//  GistsApp
//
//  Created by Yuri Marques Strack on 28/05/24.
//

import Foundation

// MARK: - Gist
struct GistResponse: Codable {
    var id: String?
    var nodeId: String?
    var url: String?
    var forksURL: String?
    var commitsURL: String?
    var gitPullURL: String?
    var gitPushURL: String?
    var htmlURL: String?
    var commentsURL: String
    var isPublic: Bool?
    var description: String?
    var comments: Int?
    var user: UserResponse?
    var owner: UserResponse?
    var files: [String: FileResponse]
    var createdAt: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, url, description, comments, user, owner, files
        case nodeId = "node_id"
        case forksURL = "forks_url"
        case commitsURL = "commits_url"
        case gitPullURL = "git_pull_url"
        case gitPushURL = "git_push_url"
        case htmlURL = "html_url"
        case commentsURL = "comments_url"
        case isPublic = "public"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - User
struct UserResponse: Codable {
    var id: Int?
    var nodeId: String?
    var login: String?
    var avatarURL: String?
    var eventsURL: String?
    var followersURL: String?
    var followingURL: String?
    var gistsURL: String?
    var gravatarId: String?
    var htmlURL: String?
    var organizationsURL: String?
    var receivedEventsURL: String?
    var reposURL: String?
    var siteAdmin: Bool?
    var starredURL: String?
    var subscriptionsURL: String?
    var type: String?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, login, type, url
        case nodeId = "node_id"
        case avatarURL = "avatar_url"
        case eventsURL = "events_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case gravatarId = "gravatar_id"
        case htmlURL = "html_url"
        case organizationsURL = "organizations_url"
        case receivedEventsURL = "received_events_url"
        case reposURL = "repos_url"
        case siteAdmin = "site_admin"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
    }
}

// MARK: - File
struct FileResponse: Codable {
    var filename: String?
    var type: String?
    var language: String?
    var rawURL: String?
    var size: Int
    
    enum CodingKeys: String, CodingKey {
        case filename, type, language, size, rawURL = "raw_url"
    }
}
