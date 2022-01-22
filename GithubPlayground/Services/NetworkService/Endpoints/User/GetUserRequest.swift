//
//  GetUserRequest.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation
import Moya

protocol GetUserRequest: DecodableResponseTargetType {}

extension GetUserRequest {
    var baseURL: URL { return URL(string: "https://api.github.com/users/")! }
    var headers: [String : String]? { return nil }
    var sampleData: Data { return Data() }
}

extension UserAPI {
    struct GetUser: GetUserRequest {
        typealias ResponseType = GetUserResponse
        
        var path: String { return "bill0930" }
        var method: Moya.Method { return .get }
        var task: Task { return .requestPlain }
    }
}

