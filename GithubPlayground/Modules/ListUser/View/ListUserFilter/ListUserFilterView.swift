//
//  ListUserFilterView.swift
//  GithubPlayground
//
//  Created by CHI YU CHAN on 23/1/2022.
//

import Foundation
import UIKit

private let reuseIdentifier = "ListUserFilterCell"

protocol ListUserFilterViewDelegate: AnyObject {
    func filterView(_ view: ListUserFilterView, didSelect index: Int)
}

class ListUserFilterView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ListUserFilterViewDelegate?
    let user: GetUserResponse
    var option: ListUserOptions = .followers {
        didSet {
            let selectedIndexPath = IndexPath(row: option.rawValue, section: 0)
            collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - LifeCycle
    
    init(option: ListUserOptions, user: GetUserResponse) {
        self.user = user

        super.init(frame: .zero)
        collectionView.register(ListUserFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let selectedIndexPath = IndexPath(row: option.rawValue, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UICollectionViewDataSource

extension ListUserFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ListUserOptions.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ListUserFilterCell
        
        let option = ListUserOptions(rawValue: indexPath.row)!
        cell.configureLabel(user: user, option: option)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ListUserFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = ListUserOptions.allCases.count
        return CGSize(width: frame.width / CGFloat(count), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UICollectionViewDelegate

extension ListUserFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filterView(self, didSelect: indexPath.row)
    }
}
