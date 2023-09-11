///
/// NSButtonCollectionViewCell.swift
///
/// Created by 정준영 on 2023/09/10.
///

import UIKit

final class NSButtonCollectionViewCell: UICollectionViewCell {
    typealias SortType = NaverShoppingEndPoint.Sort
    typealias CT = Constants
    
    /// 버튼 배경 뷰 생성
    private let backView: UIView = UIView()
        .backgroundColor(CT.sortButtonBGColor)
        .setBorder(color: CT.sortButtonBorderColor, width: CT.sortButtonBorderWidth)
        .cornerRadius(CT.sortButtonCornerRadius)
        .clipsToBounds(true)
    
    /// 타이틀 레이블 생성
    private let title: UILabel = UILabel()
        .text("Sort")
        .textColor(CT.sortButtonTitleColor)
        .textAlignment(.center)
        .font(Constants.sortButtonFont)
    
    /// 정렬 방식
    var sortType: SortType = .sim {
        didSet {
            switch sortType {
            case .sim:
                title.text("naver_sort_sim".localized)
            case .date:
                title.text("naver_sort_date".localized)
            case .asc:
                title.text("naver_sort_asc".localized)
            case .dsc:
                title.text("naver_sort_dsc".localized)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        makeShadow()
    }
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                title.textColor(CT.sortButtonTitleSelectedColor)
                backView.backgroundColor(CT.sortButtonSelectedBGColor)
            } else {
                title.textColor(CT.sortButtonTitleColor)
                backView.backgroundColor(CT.sortButtonBGColor)
            }
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI구성하기
    private func configureUI() {
        self.addSubView(backView)
        backView.addSubview(title)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        title.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8))
        }
    }
    
    /// 그림자 추가
    private func makeShadow() {
        layer.masksToBounds = false
        layer.shadowColor = CT.sortButtonShadowColor
        layer.shadowOpacity = CT.sortButtonShadowOpacity
        layer.shadowRadius = CT.sortButtonShadowRadius
        layer.shadowOffset = CT.sortButtonShadowOffset
    }
    
    /// 다크모드 변경될 때 그림자 색상 변경
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.shadowColor = CT.sortButtonShadowColor
        }
    }
    
    
}
