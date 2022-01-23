//
//  ListUserController.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation
import UIKit
import PromiseKit
import NotificationBannerSwift

private let reuseIdentifier = "ListUserTableViewCell"

enum ListUserOptions: Int, CaseIterable {
    case followers
    case following
    
    var description: String {
        switch self {
        case .followers: return "followers"
        case .following: return "following"
        }
    }
}

class ListUserController: UIViewController {
    
    // MARK: - Properties
    
    var router: ListUserRouterProtocol?
    
    private var networkService: NetworkServiceProtocol {
        return DependenciesConfigurator.shared.container.resolve(NetworkServiceProtocol.self)!
    }
    
    var option: ListUserOptions = .followers {
        didSet {
            tableView.reloadData()
        }
    }
    let user: GetUserResponse
    var followings = [UserListable]() {
        didSet {
            tableView.reloadData()
        }
    }
    var followers = [UserListable]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var filterBar = ListUserFilterView(option: .followers,
                                                    user: user)
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(ListUserTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.rowHeight = 60.0
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        view.backgroundColor = .speerYellow
        configureUI()
        configureRouter()

        fetchUsers(option: .followers, forPage: 1)
        fetchUsers(option: .following, forPage: 1)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Transparent UINavigationBar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    init(option: ListUserOptions, user: GetUserResponse) {
        self.option = option
        self.user = user
        super.init(nibName: nil, bundle: nil)
        filterBar.option = option
        filterBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - API
    private func fetchFollowers(forPage page: Int) -> Promise<[Followers]> {
        return Promise<[Followers]> { seal in
            networkService.request(UserAPI.GetFollowers(username: user.username,
                                                        page: page))
                .done { response in
                    seal.fulfill(response)
                }.catch { error in
                    seal.reject(error)
                }
        }
    }
    
    private func fetchFollowings(forPage page: Int) -> Promise<[Following]> {
        return Promise<[Following]> { seal in
            networkService.request(UserAPI.GetFollowing(username: user.username,
                                                        page: page))
                .done { response in
                    seal.fulfill(response)
                }.catch { error in
                    seal.reject(error)
                }
        }
    }
    
    private func fetchUser(username: String) -> Promise<GetUserResponse> {
        return Promise<GetUserResponse> { seal in
            networkService.request(UserAPI.GetUser(username: username))
                .done { user in
                    seal.fulfill(user)
                }.catch { error in
                    seal.reject(error)
                }
        }
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.addSubview(filterBar)
        view.addSubview(tableView)
        
        filterBar.snp.makeConstraints {
            $0.top.equalTo(120)
            $0.height.equalTo(50)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(filterBar.snp.bottom)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureRouter() {
        let router = ListUserRouter()
        router.navigationController = navigationController
        self.router = router
    }
    
    private func fetchUsers(option: ListUserOptions, forPage page: Int) {
        switch option {
        case .followers:
            fetchFollowers(forPage: page).done { followers in
                self.followers += followers
            }.catch { _ in
                self.showTryAgainBanner()
            }.finally {
                self.tableView.reloadData()
            }
        case .following:
            fetchFollowings(forPage: page).done { followings in
                self.followings += followings
            }.catch { _ in
                self.showTryAgainBanner()
            }.finally {
                self.tableView.reloadData()
            }
        }
        
    }
    
    private func showTryAgainBanner() {
        let title = "Please try again later"
        let banner = StatusBarNotificationBanner(title: title, style: .danger)
        banner.show()
    }
}

extension ListUserController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch option {
        case .following:
            return followings.count
        case .followers:
            return followers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ListUserTableViewCell {
            switch option {
            case .following:
                cell.configureCell(imageUrl: followings[indexPath.row].avatarUrl ?? "",
                                   username: followings[indexPath.row].username)
            case .followers:
                cell.configureCell(imageUrl: followers[indexPath.row].avatarUrl ?? "",
                                   username: followers[indexPath.row].username)
            }
            return cell
        } else {
            return ListUserTableViewCell()
        }
    }
    
    
}

// MARK: - UITableViewDelegate
extension ListUserController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataSource = option == .followers ? followers[indexPath.row] : followings[indexPath.row]
        fetchUser(username: dataSource.username).done { user in
            self.router?.navigateToUserInfoVC(user: user)
        }
    }
}

// MARK: - ListUserFilterViewDelegate
extension ListUserController: ListUserFilterViewDelegate {
    func filterView(_ view: ListUserFilterView, didSelect index: Int) {
        option = ListUserOptions(rawValue: index) ?? .followers
    }
}

// MARK: - UIScrollViewDelegate

extension ListUserController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let ratio = scrollView.contentOffset.y / scrollView.contentSize.height
        if ratio > 0.6 {
            switch option {
            case .followers:
                if followers.count < user.followers {
                    let page = followers.count / 20
                    fetchUsers(option: .followers, forPage: page + 1)
                }
            case .following:
                if followings.count < user.following {
                    let page = followings.count / 20
                    fetchUsers(option: .following, forPage: page + 1)
                }
            }
        }
    }
}
