//
//  UserInfoController.swift
//  GithubPlayground
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation
import UIKit
import SDWebImage
import PromiseKit
import NotificationBannerSwift

private struct Constants {
    static let bioTextViewHeight: CGFloat = 75.0
    static let profileImageTopMargin: CGFloat = 12.0
    static let profileImageSize: CGSize = CGSize(width: 250, height: 250)
    static let labelHeight: CGFloat = 48.0
    static let defaultBio: String = "This user is lazy. He/She does not write anything."
}

class UserInfoController: UIViewController {
    
    // MARK: - Properties
    
    var router: UserInfoRouterProtocol?
    
    private var networkService: NetworkServiceProtocol {
        return DependenciesConfigurator.shared.container.resolve(NetworkServiceProtocol.self)!
    }
    
    var user: GetUserResponse
    
    let refreshControl = UIRefreshControl()
    
    let scrollView: UIScrollView = UIScrollView()
    let contentView: UIView = UIView()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.profileImageSize.width / 2
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldMainFont(ofSize: 28)
        label.textColor = .black
        label.text = "name"
        label.textAlignment = .center
        label.snp.makeConstraints {
            $0.height.equalTo(Constants.labelHeight)
        }
        return label
    }()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mainFont(ofSize: 24)
        label.textColor = .black
        label.text = "@bill0930"
        label.textAlignment = .center
        label.snp.makeConstraints {
            $0.height.equalTo(Constants.labelHeight)
        }
        return label
    }()

    private let bioTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .darkGray
        textView.backgroundColor = .clear
        textView.font = UIFont.mainFont(ofSize: 16)
        textView.textContainer.lineBreakMode = .byCharWrapping
        textView.isEditable = false
        textView.snp.makeConstraints {
            $0.height.equalTo(Constants.bioTextViewHeight)
        }
        return textView
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mainFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onFollowersTapped))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mainFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onFollowingTapped))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        configureRouter()
        configureUI()
        configureUser()
        configureRefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {        
        // Transparent UINavigationBar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    init(user: GetUserResponse) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - API
    
    private func fetchUser() -> Promise<GetUserResponse> {
        return Promise<GetUserResponse> { seal in
            networkService.request(UserAPI.GetUser(username: user.username))
                .done { user in
                    self.user = user
                    seal.fulfill(user)
                }.catch { error in
                    seal.reject(error)
                }
        }
    }
    
    // MARK: - Selectors
    
    @objc private func refresh() {
        fetchUser().done { [weak self] _ in
            self?.configureUser()
        }.catch { _ in
            self.showTryAgainBanner()
        }.finally { [weak self]  in
            self?.refreshControl.endRefreshing()
            self?.configureUser()
        }
    }
    
    @objc private func onFollowersTapped() {
        router?.navigateToListUserVC(option: .followers, user: user)
    }
    
    @objc private func onFollowingTapped() {
        router?.navigateToListUserVC(option: .following, user: user)
    }
    
    // MARK: - Helpers
    
    private func configureRouter() {
        let router = UserInfoRouter()
        router.navigationController = navigationController
        self.router = router
    }
    
    private func configureUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.leading.equalTo(scrollView.snp.leading)
            $0.top.equalTo(scrollView.snp.top)
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(view.bounds.height - 48)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        scrollView.backgroundColor = .speerYellow
        contentView.backgroundColor = .speerYellow
        contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(Constants.profileImageTopMargin)
            $0.size.equalTo(Constants.profileImageSize)
            $0.centerX.equalToSuperview()
        }
        
        let vStack = UIStackView(arrangedSubviews: [nameLabel,
                                                    usernameLabel,
                                                    bioTextView])
        vStack.axis = .vertical
        vStack.spacing = 8.0
        vStack.distribution = .fill
        vStack.addArrangedSubview(nameLabel)
        vStack.addArrangedSubview(usernameLabel)
        vStack.addArrangedSubview(bioTextView)
        
        contentView.addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(50)
            $0.left.equalTo(UIConfig.commonMargin)
            $0.right.equalTo(-UIConfig.commonMargin)
        }
        
        contentView.addSubview(followingLabel)
        contentView.addSubview(followersLabel)
        
        
        let hStack = UIStackView(arrangedSubviews: [followersLabel,
                                                    followingLabel])
        hStack.axis = .horizontal
        hStack.spacing = 8.0
        hStack.alignment = .center
        hStack.distribution = .fillEqually
        contentView.addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.top.equalTo(vStack.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.left.equalTo(UIConfig.commonMargin)
            $0.right.equalTo(-UIConfig.commonMargin)
        }
    }
    
    private func configureUser() {
        profileImageView.sd_setImage(with: URL(string: user.avatarUrl ?? ""), completed: nil)
        nameLabel.text = user.name ?? user.username
        usernameLabel.text = "@\(user.username)"
        bioTextView.text = user.bio ?? Constants.defaultBio
        followersLabel.attributedText = attributedText(withValue: user.followers, text: "Followes")
        followingLabel.attributedText = attributedText(withValue: user.following, text: "Following")
    }
    
    private func configureRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
           scrollView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    // A function for creating attributedText of XXX followers and XXX following
    private func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [.font: UIFont.boldMainFont(ofSize: 16)])
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                                  attributes: [.font: UIFont.mainFont(ofSize: 16),
                                                               .foregroundColor: UIColor.black]))
        return attributedTitle
    }
    
    private func showTryAgainBanner() {
        let title = "Please try again later"
        let banner = StatusBarNotificationBanner(title: title, style: .danger)
        banner.show()
    }
    
}
