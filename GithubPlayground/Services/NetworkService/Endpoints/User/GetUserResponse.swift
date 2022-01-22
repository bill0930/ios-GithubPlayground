//
//  GetUserResponse.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation

struct GetUserResponse: Decodable {
    var avatarUrl: String?
    var username: String
    var name: String?
    var bio: String?
    var followers: Int
    var following: Int

    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case username = "login"
        case name
        case bio
        case followers
        case following
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avatarUrl = try container.decode(String?.self, forKey: .avatarUrl)
        username = try container.decode(String.self, forKey: .username)
        name = try container.decode(String?.self, forKey: .name)
        bio = try container.decode(String?.self, forKey: .bio)
        followers = try container.decode(Int.self, forKey: .followers)
        following = try container.decode(Int.self, forKey: .following)
    }
    
}
