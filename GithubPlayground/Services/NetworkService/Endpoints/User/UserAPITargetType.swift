//
//  UserAPITargetType.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation

protocol UserAPITargetType: DecodableResponseTargetType {}

extension UserAPITargetType {
    var headers: [String : String]? { return
        ["accept": "application/vnd.github.v3+json"]
    }
}
