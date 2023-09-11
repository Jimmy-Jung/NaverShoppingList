//
//  NSResultCollectionViewCell.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import UIKit
import JimmyKit
import RealmSwift

final class NSResultCollectionViewCell: UICollectionViewCell {
    typealias CT = Constants
    
    private let realm = RealmManager.createRealm(path: .favorite)
    
    /// 검색 결과 목록을 구성하는 셀에 표시할 정보를 설정하는 메소드
    var shoppingData: ShoppingData? {
        didSet {
            guard let data = shoppingData else { return }
            let realmShoppingData = realm.objects(RealmShoppingData.self)
            let storedShoppingData = realmShoppingData.where {
                $0.productID == data.productID
            }.first
            if storedShoppingData != nil {
                heartButton.isSelected = true
            } else {
                heartButton.isSelected = false
            }
            
            // 검색 결과 셀에 표시할 정보 설정
            let mallName = "[" + data.mallName + "]"
            let title = data.title.htmlToString
            let price = data.lprice
            mallNameLabel.text(mallName)
            titleLabel.text(title)
            lowPriceLabel.text(price.formatWithCommas())
            if let image = RealmManager.loadImageFromDocument(fileName: data.productID) {
                imageView.image(image)
            } else {
                imageView.setImage(with: data.image, placeHolder: CT.resultCellPlaceholderImage, transition: .fade())
            }
        }
    }
    
    /// 검색 결과 셀에 표시할 이미지 뷰 생성
    let imageView: UIImageView = UIImageView()
        .image(CT.resultCellPlaceholderImage)
        .tintColor(CT.resultCellPlaceholderImageTintColor)
        .contentMode(.scaleAspectFill)
        .cornerRadius(CT.resultCellImageCornerRadius)
        .clipsToBounds(true)
    
    /// 검색 결과 셀에 표시할 하트 버튼 생성
    lazy var heartButton: UIButton = {
        let button = UIButton()
            .backgroundColor(CT.resultCellHeartButtonBGColor)
            .tintColor(CT.resultCellHeartButtonTintColor)
            .cornerRadius(CT.resultCellHeartButtonWidth/2)
            .clipsToBounds(true)
        
        // 하트 버튼 이미지 설정
        button.setImage(CT.resultCellHeartButtonImage, for: .normal)
        button.setImage(CT.resultCellHeartButtonSelectedImage, for: .selected)
        return button
    }()
    
    /// 검색 결과 셀에 표시할 쇼핑몰명 레이블 생성
    private let mallNameLabel: UILabel = UILabel()
        .font(CT.resultCellMallNameLabelFont)
        .textColor(CT.resultCellMallNameLabelColor)
    
    /// 검색 결과 셀에 표시할 상품명 레이블 생성
    private let titleLabel: UILabel = UILabel()
        .font(CT.resultCellTitleLabelFont)
        .textColor(CT.resultCellTitleLabelColor)
        .numberOfLines(2)
    
    /// 검색 결과 셀에 표시할 최저가 레이블 생성
    private let lowPriceLabel: UILabel = UILabel()
        .font(CT.resultCellLowPriceLabelFont)
        .textColor(CT.resultCellLowPriceLabelColor)
    
    /// 검색 결과 셀에 표시할 뷰 생성
    private lazy var verticalStackView: UIStackView = UIStackView()
        .addArrangedSubview(mallNameLabel)
        .addArrangedSubview(titleLabel)
        .addArrangedSubview(lowPriceLabel)
        .addArrangedSubview(UIView())
        .axis(.vertical)
        .spacing(0)
        .alignment(.fill)
        .distribution(.fill)
    
    /// 초기화 메소드
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubView(heartButton)
        addSubView(verticalStackView)
        setConstraints()
    }
    
    /// 검색 결과 셀에서 재사용할 때 호출되는 메소드
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    /// 제약 설정 메소드
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        heartButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(imageView.snp.bottom).offset(-10)
            make.size.equalTo(CT.resultCellHeartButtonWidth)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
