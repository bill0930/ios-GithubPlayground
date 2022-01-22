//
//  MoyaConfig.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation
import Moya

class MoyaConfig {
    static func JSONResponseDataFormatter(_ data: Data) -> String {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
        } catch {
            return String(data: data, encoding: .utf8) ?? ""
        }
    }

    static var plugin = NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter),
                                                                     logOptions: .verbose))
}
