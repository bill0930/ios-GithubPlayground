//
//  ListUserFilterCell.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 23/1/2022.
//

import UIKit

class ListUserFilterCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldMainFont(ofSize: 14)
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.boldMainFont(ofSize: 16) : UIFont.mainFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .black : .lightGray
        }
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(24.0)
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Helpers
    
    func configureLabel(user: GetUserResponse,
                        option: ListUserOptions) {
        switch option {
        case .followers:
            titleLabel.text = "\(user.followers) \(option.description)"
        case .following:
            titleLabel.text = "\(user.following) \(option.description)"
        }
    }

}
