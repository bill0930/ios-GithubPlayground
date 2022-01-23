//
//  GetFollowingResponse.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation

struct GetFollowingResponse: Decodable {
    var avatarUrl: String?
    var username: String

    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case username = "login"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avatarUrl = try container.decode(String?.self, forKey: .avatarUrl)
        username = try container.decode(String.self, forKey: .username)
    }

}
