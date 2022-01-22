//
//  DecodableResponseTargetType.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation
import Moya

protocol DecodableResponseTargetType: TargetType {
  associatedtype ResponseType: Decodable
}
