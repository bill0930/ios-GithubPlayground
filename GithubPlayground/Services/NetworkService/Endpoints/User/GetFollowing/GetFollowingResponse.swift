//
//  GetFollowingResponse.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation

struct GetFollowingResponse: Decodable {
    var followings: [Following]
}
