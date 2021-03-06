//
//  GetUserRequest.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation
import Moya

protocol GetUserRequest: UserAPITargetType {}

extension GetUserRequest {
    var baseURL: URL { return URL(string: "https://api.github.com/users/")! }
}

extension UserAPI {
    struct GetUser: GetUserRequest {
        typealias ResponseType = GetUserResponse
        var path: String
        var method: Moya.Method { return .get }
        var task: Task { return .requestPlain }
        
        init(username: String) {
            path = username
        }
    }
}

