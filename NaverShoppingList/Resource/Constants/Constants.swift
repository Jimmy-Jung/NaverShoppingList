//
//  Constants.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import UIKit

enum Constants {
    typealias SFConfig = UIImage.SymbolConfiguration
    // MARK: - NSButtonCollectionViewCell
 
    static let sortButtonFont: UIFont = .systemFont(ofSize: 15, weight: .bold)
    static let sortButtonBGColor: UIColor = .systemBackground
    static let sortButtonSelectedBGColor: UIColor = .label
    static let sortButtonBorderColor: UIColor = .secondaryLabel
    static let sortButtonBorderWidth: CGFloat = 1
    static let sortButtonCornerRadius: CGFloat = 10
    
    static let sortButtonTitleColor: UIColor = .secondaryLabel
    static let sortButtonTitleSelectedColor: UIColor = .systemBackground
    
    static let sortButtonShadowColor: CGColor = UIColor.secondaryLabel.cgColor
    static let sortButtonShadowOpacity: Float = 0.4
    static let sortButtonShadowRadius: CGFloat = 2
    static let sortButtonShadowOffset: CGSize = CGSize(width: 0, height: 2)
    
    // MARK: - NSResultCollectionViewCell
    
    static let resultCellPlaceholderImage: UIImage? = UIImage(systemName: "photo")
    static let resultCellPlaceholderImageTintColor: UIColor = .secondaryLabel
    static let resultCellImageCornerRadius: CGFloat = 10
    static let resultCellHeartButtonBGColor: UIColor = .systemBackground
    static let resultCellHeartButtonTintColor: UIColor = .label
    static let resultCellHeartButtonWidth: CGFloat = 40
    static let resultCellHeartButtonImage: UIImage? = UIImage(systemName: "heart", withConfiguration: SFConfig(pointSize: 20, weight: .medium))
    static let resultCellHeartButtonSelectedImage: UIImage? = UIImage(systemName: "heart.fill", withConfiguration: SFConfig(pointSize: 20, weight: .medium))
    
    static let resultCellMallNameLabelFont: UIFont = .systemFont(ofSize: 13, weight: .medium)
    static let resultCellMallNameLabelColor: UIColor = .secondaryLabel
    
    static let resultCellTitleLabelFont: UIFont = .systemFont(ofSize: 14, weight: .medium)
    static let resultCellTitleLabelColor: UIColor = .label
    
    static let resultCellLowPriceLabelFont: UIFont = .systemFont(ofSize: 16, weight: .heavy)
    static let resultCellLowPriceLabelColor: UIColor = .label
    
    // MARK: - NSTabBarController
    static let tabBarShadowColor: CGColor = UIColor.gray.cgColor
    static let tabBarShadowOffset: CGSize = CGSize(width: 0, height: -2)
    static let tabBarShadowOpacity: Float = 0.5
    static let tabBarShadowRadius: CGFloat = 10

    
}
