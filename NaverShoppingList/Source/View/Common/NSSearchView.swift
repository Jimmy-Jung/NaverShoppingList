//
//  NaverSearchView.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import UIKit
import JimmyKit
import SnapKit

final class NSSearchView: UIView {

    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = NSSearchString.searchBarPlaceholder
        sb.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        sb.setValue("취소", forKey: "cancelButtonText")
        sb.setShowsCancelButton(true, animated: true)
        sb.tintColor = .label
        return sb
    }()
    
    let sortButtonCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let resultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout(
            numberOfRows: 2,
            additionalHeight: 76,
            spacing: 10,
            inset: .init(top: 0, left: 10, bottom: 0, right: 10)
        )
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor(.systemBackground)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [searchBar, sortButtonCollectionView, resultsCollectionView].forEach { self.addSubView($0) }
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        sortButtonCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        resultsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sortButtonCollectionView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

}
