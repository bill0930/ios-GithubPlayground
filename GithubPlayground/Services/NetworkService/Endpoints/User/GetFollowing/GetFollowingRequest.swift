//
//  GetFollowingRequest.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation
import Moya

protocol GetFollowingRequest: UserAPITargetType {}

extension GetFollowingRequest {
    var baseURL: URL { return URL(string: "https://api.github.com/users/")! }
}

extension UserAPI {
    struct GetFollowing: GetFollowingRequest {
        typealias ResponseType = [Following]
        var path: String
        var method: Moya.Method { return .get }
        var task: Task
        
        init(username: String, perPage: Int = 20, page: Int = 1) {
            path = "\(username)/following"
            self.task = Task.requestParameters(parameters: ["per_page": perPage,
                                                           "page": page],
                                              encoding: URLEncoding.default )
        }
    }
}
