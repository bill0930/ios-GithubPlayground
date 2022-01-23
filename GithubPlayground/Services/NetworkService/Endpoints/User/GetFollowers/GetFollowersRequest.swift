//
//  GetFollowersRequest.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 23/1/2022.
//


import Foundation
import Moya

protocol GetFollowersRequest: UserAPITargetType {}

extension GetFollowersRequest {
    var baseURL: URL { return URL(string: "https://api.github.com/users/")! }
}

extension UserAPI {
    struct GetFollowers: GetFollowersRequest {
        typealias ResponseType = [Followers]
        var path: String
        var method: Moya.Method { return .get }
        var task: Task

        init(username: String, perPage: Int = 20, page: Int = 1) {
            path = "\(username)/followers"
            self.task = Task.requestParameters(parameters: ["per_page": perPage,
                                                           "page": page],
                                              encoding: URLEncoding.default )
        }
    }
}
