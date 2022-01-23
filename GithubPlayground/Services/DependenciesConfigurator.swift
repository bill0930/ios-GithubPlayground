//
//  DependenciesConfigurator.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation
import Swinject
import Moya

class DependenciesConfigurator {
    
    static let shared = DependenciesConfigurator()
    
    var container: Container
    
    func registerServices() {
        container.register(NetworkServiceProtocol.self) { _ in
            return NetworkService(provider: MoyaProvider<MultiTarget>(plugins: [MoyaConfig.plugin]))
        }
    }
    
    init() {
        container = Container()
    }
}
