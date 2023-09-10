//
//  NSButtonCollectionViewCell.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import UIKit

final class NSButtonCollectionViewCell: UICollectionViewCell {
    typealias SortType = NaverShoppingEndPoint.Sort
    
    private let backView: UIView = UIView()
        .backgroundColor(.systemBackground)
        .setBorder(color: .secondaryLabel, width: 1)
        .cornerRadius(10)
        .clipsToBounds(true)
    
    private let title: UILabel = UILabel()
        .text("Sort")
        .textColor(.secondaryLabel)
        .textAlignment(.center)
        .font(UIConstants.sortButtonFont)
    
    var sortType: SortType = .sim {
        didSet {
            switch sortType {
            case .sim:
                title.text(NSSearchString.sim)
            case .date:
                title.text(NSSearchString.date)
            case .asc:
                title.text(NSSearchString.asc)
            case .dsc:
                title.text(NSSearchString.dsc)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubView(backView)
        backView.addSubview(title)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        title.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8))
        }
        makeShadow()
    }
    override var isSelected: Bool {
        didSet {
            isSelected ? (title.textColor = .systemBackground) : (title.textColor = .secondaryLabel)
            isSelected ? (backView.backgroundColor = .label) : (backView.backgroundColor = .systemBackground)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.secondaryLabel.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13, *), self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.shadowColor = UIColor.secondaryLabel.cgColor
        }
    }
    
    
}
