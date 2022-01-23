//
//  UserInfoRouter.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 23/1/2022.
//

import Foundation
import UIKit

protocol UserInfoRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set }

    func navigateToListUserVC(option: ListUserOptions, user: GetUserResponse)
}

class UserInfoRouter: UserInfoRouterProtocol {
    var navigationController: UINavigationController?
    
    func navigateToListUserVC(option: ListUserOptions, user: GetUserResponse) {
        let vc = ListUserController(option: option, user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}
