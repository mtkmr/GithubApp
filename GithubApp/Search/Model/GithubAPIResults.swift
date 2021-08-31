//
//  GithubAPIResults.swift
//  GithubApp
//
//  Created by Masato Takamura on 2021/08/30.
//

import Foundation

struct GithubAPIResults: Codable {
    let items: [Item]
}

struct Item: Codable {
    let owner: Owner
    let repositoryUrl: String
    
    enum CodingKeys: String, CodingKey {
        case owner
        case repositoryUrl = "html_url"
    }
}

struct Owner: Codable {
    let name: String
    let avatar: String
    
    enum CodingKeys: String, CodingKey {
        case name = "login"
        case avatar = "avatar_url"
    }
}
