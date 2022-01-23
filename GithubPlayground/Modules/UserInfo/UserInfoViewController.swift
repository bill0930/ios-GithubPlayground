//
//  UserInfoViewController.swift
//  GithubPlayground
//
//    Avatar
//    Username
//    Name
//    Description
//    Follower count, i.e. X followers
//    Following count, i.e. X following
//
//  Created by CHI YU CHAN on 22/1/2022.
//

import Foundation
import UIKit
import SDWebImage

private struct Constants {
    static let bioTextViewHeight: CGFloat = 75.0
    static let profileImageTopMargin: CGFloat = 100.0
    static let profileImageSize: CGSize = CGSize(width: 250, height: 250)
    static let labelHeight: CGFloat = 48.0

}

class UserInfoViewController: UIViewController {
    
    // MARK: - Properties
    
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
    
    private let usernameLabel: UILabel = {
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
        textView.text = "OpenVanilla is a collection of Mac input methods that primarily serve Traditional Chinese users"
        return textView
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mainFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mainFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        configureUI()
        let url = URL(string: "https://avatars.githubusercontent.com/u/43231465?s=96&v=4")
        profileImageView.sd_setImage(with: url, completed: nil)
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .speerYellow
        view.addSubview(profileImageView)
        
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
        
        view.addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(50)
            $0.left.equalTo(UIConfig.commonMargin)
            $0.right.equalTo(UIConfig.commonMargin)
        }
        
        view.addSubview(followingLabel)
        view.addSubview(followersLabel)
        
        
        let hStack = UIStackView(arrangedSubviews: [followersLabel,
                                                    followingLabel])
        hStack.axis = .horizontal
        hStack.spacing = 8.0
        hStack.alignment = .center
        hStack.distribution = .fillEqually
        view.addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.top.equalTo(vStack.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.left.equalTo(UIConfig.commonMargin)
            $0.right.equalTo(UIConfig.commonMargin)
        }
        
        followersLabel.attributedText = attributedText(withValue: 200, text: "followers")
        followingLabel.attributedText = attributedText(withValue: 500, text: "following")

//        hStack.addArrangedSubview(followersLabel)
//        hStack.addArrangedSubview(followingLabel)
//        vStack.addArrangedSubview(hStack)
        
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
    
}
