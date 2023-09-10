//
//  NSResultCollectionViewCell.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import UIKit
import JimmyKit

final class NSResultCollectionViewCell: UICollectionViewCell {
    typealias SFConfig = UIImage.SymbolConfiguration
    
    var shoppingData: ShoppingData? {
        didSet {
            guard let data = shoppingData else { return }
            let mallName = "[" + data.mallName + "]"
            let title = data.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
            let price = data.lprice
            mallNameLabel.text(mallName)
            titleLabel.text(title)
            lowPriceLabel.text(price.formatWithCommas())
            imageView.setImage(with: data.image, placeHolder: UIImage(systemName: "photo"), transition: .fade(0.3))
        }
    }
    private let imageView: UIImageView = UIImageView()
        .backgroundColor(.secondarySystemFill)
        .image(UIImage(systemName: "photo"))
        .contentMode(.scaleAspectFill)
        .cornerRadius(10)
        .clipsToBounds(true)
    
    private lazy var heartButton: UIButton = {
        let button = UIButton()
            .backgroundColor(.systemBackground)
            .tintColor(.label)
            .cornerRadius(20)
            .clipsToBounds(true)
        
        button.setImage(
            UIImage(
                systemName: "heart",
                withConfiguration: SFConfig(pointSize: 20, weight: .medium)
            ),
            for: .normal
        )
        button.setImage(
            UIImage(
                systemName: "heart.fill",
                withConfiguration: SFConfig(pointSize: 20, weight: .medium)
            ),
            for: .selected
        )
        return button
    }()
    
    private let mallNameLabel: UILabel = UILabel()
        .font(.systemFont(ofSize: 13, weight: .medium))
        .textColor(.secondaryLabel)
    
    private let titleLabel: UILabel = UILabel()
        .font(.systemFont(ofSize: 14, weight: .medium))
        .textColor(.label)
        .numberOfLines(2)
    
    private let lowPriceLabel: UILabel = UILabel()
        .font(.systemFont(ofSize: 16, weight: .heavy))
        .textColor(.label)
    
    private lazy var verticalStackView: UIStackView = UIStackView()
        .addArrangedSubview(mallNameLabel)
        .addArrangedSubview(titleLabel)
        .addArrangedSubview(lowPriceLabel)
        .addArrangedSubview(UIView())
        .axis(.vertical)
        .spacing(0)
        .alignment(.fill)
        .distribution(.fill)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubView(heartButton)
        addSubView(verticalStackView)
        setConstraints()
    }
    
    private func setConstraints() {
        // Constraints for imageView
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }

        // Constraints for heartButton
        heartButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(imageView.snp.bottom).offset(-10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }

        // Constraints for verticalStackView
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

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct NSCollectionViewCell_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = NSResultCollectionViewCell(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width / 2 - 20, height: 200))
            return view
        }
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}
#endif
