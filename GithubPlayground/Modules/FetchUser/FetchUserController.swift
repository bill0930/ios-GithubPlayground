//
//  FetchUser.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation
import UIKit
import SnapKit

private struct Constants {
    static let searchBarHeight: CGFloat = 24.0
    static let searchBarWidth: CGFloat = 250.0
    static let searchBarPlaceHolder = "Github username?"
}

class FetchUserController: UIViewController {
    
    // MARK: - Properties
    
    private var networkService: NetworkServiceProtocol
    
    private lazy var searchFieldStack: UIStackView = {
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
    
    private func fetchUser() {
        networkService.request(UserAPI.GetUser(username: searchTextField.text ?? ""))
            .done { user in
                // TODO: - push a new view controller
            }.catch { error in
                // TODO: - show a alert that 404b
            }
    }
    
    // MARK: - Selectors
    
    @objc private func handleFetchUser() {
        fetchUser()
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .speerYellow
        view.addSubview(searchFieldStack)
        
        searchFieldStack.snp.makeConstraints {
            $0.top.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints {
            $0.height.equalTo(Constants.searchBarHeight)
            $0.width.equalTo(Constants.searchBarWidth)
        }
        
        searchFieldStack.addArrangedSubview(searchTextField)
        searchFieldStack.addArrangedSubview(searchButton)
    }
    
    private func configureKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
}


// MARK: - UITextFieldDelegate
extension FetchUserController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleFetchUser()
        return true
    }
}
