//
//  FetchUser.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation
import UIKit
import SnapKit
import PromiseKit
import NotificationBannerSwift

private struct Constants {
    static let searchBarHeight: CGFloat = 24.0
    static let searchBarWidth: CGFloat = 250.0
    static let searchBarPlaceHolder = "Github username?"
}

class FetchUserController: UIViewController {
    
    // MARK: - Properties
    
    var router: FetchUserRouterProtocol?
    
    private var networkService: NetworkServiceProtocol
    
    private lazy var searchbarStack: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4.0
        return stackView
    }()

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.borderStyle = .none
        textField.font = UIFont.mainFont(ofSize: 24)
        textField.textAlignment = .left
        textField.autocapitalizationType = .none
        textField.placeholder = Constants.searchBarPlaceHolder
        textField.returnKeyType = UIReturnKeyType.search

        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("search", for: .normal)
        button.titleLabel?.font = UIFont.mainFont(ofSize: 24.0)
        button.addTarget(self, action: #selector(handleFetchUser), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        configureUI()
        configureKeyboard()
        configureRouter()
        searchTextField.becomeFirstResponder()
    }
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - API
    
    private func fetchUser() -> Promise<GetUserResponse> {
        return Promise<GetUserResponse> { seal in
            networkService.request(UserAPI.GetUser(username: searchTextField.text ?? ""))
                .done { user in
                    seal.fulfill(user)
                }.catch { error in
                    seal.reject(error)
                }
        }
    }
    
    // MARK: - Selectors
    
    @objc private func handleFetchUser() {
        fetchUser().done { [weak self] user in
            self?.router?.navigateToUserInfoVC(user: user)
        }.catch { _ in
            self.searchTextField.shake()
            self.showNotFoundBanner()
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .speerYellow
        view.addSubview(searchbarStack)
        
        searchbarStack.snp.makeConstraints {
            $0.top.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints {
            $0.height.equalTo(Constants.searchBarHeight)
            $0.width.equalTo(Constants.searchBarWidth)
        }
        
        searchbarStack.addArrangedSubview(searchTextField)
        searchbarStack.addArrangedSubview(searchButton)
    }
    
    private func configureKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func configureRouter() {
        let router = FetchUserRouter()
        router.navigationController = navigationController
        self.router = router
    }
    private func showNotFoundBanner() {
        let title = "User Not Found"
        let banner = StatusBarNotificationBanner(title: title, style: .danger)
        banner.show()
    }
}


// MARK: - UITextFieldDelegate
extension FetchUserController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleFetchUser()
        return true
    }
}

fileprivate extension UITextField {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}
