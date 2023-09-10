//
//  ShoppingResult.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/09.
//

import Foundation
// MARK: - Welcome
struct ShoppingResult: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [ShoppingData]
}

// MARK: - Item
struct ShoppingData: Codable {
    let title: String
    let link: String
    let image: String
    let mallName: String
    let lprice, hprice, productID: String
    let productType: String
    let brand, maker: String
    let category1: String
    let category2: String
    let category3: String
    let category4: String

    enum CodingKeys: String, CodingKey {
        case title, link, image, lprice, hprice, mallName
        case productID = "productId"
        case productType, brand, maker, category1, category2, category3, category4
    }
}
