//
//  ListUserRouter.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 23/1/2022.
//

import Foundation
import UIKit

protocol ListUserRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set }

    func navigateToUserInfoVC(user: GetUserResponse)
}

class ListUserRouter: ListUserRouterProtocol {
    var navigationController: UINavigationController?
    
    func navigateToUserInfoVC(user: GetUserResponse) {
        let vc = UserInfoController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}
