//
//  NaverSearchView.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import UIKit
import JimmyKit
import SnapKit

/// NSSearchView 클래스 정의
final class NSSearchView: UIView {
    
    /// UISearchBar 인스턴스 생성
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "searchBar_placeholder".localized // 플레이스홀더 지정
        sb.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        sb.setValue("cancel_button".localized, forKey: "cancelButtonText") // 취소 버튼 이름 변경
        sb.setShowsCancelButton(true, animated: true)
        sb.tintColor = .label // 커서 색상 지정
        return sb
    }()
    
    /// 버튼 CollectionView와 검색 결과 CollectionView를 포함하는 수직 StackView 생성
    private lazy var verticalStackView: UIStackView = UIStackView()
        .addArrangedSubview(sortButtonCollectionView)
        .addArrangedSubview(resultsCollectionView)
        .axis(.vertical)
        .spacing(8)
        .alignment(.fill)
        .distribution(.fill)
    
    /// 정렬 버튼 CollectionView 생성
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
    
    /// 검색 결과 CollectionView 생성
    let resultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout(
            numberOfRows: 2,
            additionalHeight: 76,
            spacing: 10,
            inset: .init(top: 0, left: 10, bottom: 10, right: 10)
        )
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor(.systemBackground)
        return cv
    }()
    
    /// NSSearchView 클래스 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        [searchBar, verticalStackView].forEach { self.addSubView($0) }
        configureUI()
    }
    
    /// NSSearchView 클래스 초기화 실패 처리
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI 설정 메소드
    private func configureUI() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        sortButtonCollectionView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
}
