//
//  FetchUserRouter.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation
import UIKit

protocol FetchUserRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set }

    func navigateToUserInfoVC(user: GetUserResponse)
}

class FetchUserRouter: FetchUserRouterProtocol {
    var navigationController: UINavigationController?
    
    func navigateToUserInfoVC(user: GetUserResponse) {
        let vc = UserInfoController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}
