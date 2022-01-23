//
//  UserListable.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 23/1/2022.
//

import Foundation

protocol UserListable {
    var avatarUrl: String? { get set }
    var username: String { get set }
}
