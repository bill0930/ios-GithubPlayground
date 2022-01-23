//
//  GetFollowersResponse.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 23/1/2022.
//

import Foundation

struct GetFollowersResponse: Decodable {
    var follwers: [Followers]
}
