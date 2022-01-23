//
//  ListUserTableViewCell.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 23/1/2022.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "ListUserTableViewCell"

private struct Constants {
    static let profileImageSize: CGSize = CGSize(width: 50, height: 50)
}

class ListUserTableViewCell: UITableViewCell {
    
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldMainFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(profileImageView)
        addSubview(titleLabel)
        
        profileImageView.snp.makeConstraints {
            $0.left.equalTo(UIConfig.commonMargin)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Constants.profileImageSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(profileImageView.snp.right).offset(8)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(imageUrl: String, username: String) {
        let url = URL(string: imageUrl)
        profileImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = username
    }
    

}
