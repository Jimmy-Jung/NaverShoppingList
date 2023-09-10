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

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.productID == rhs.productID
    }
    
    enum CodingKeys: String, CodingKey {
        case title, link, image, lprice, hprice, mallName
        case productID = "productId"
        case productType, brand, maker, category1, category2, category3, category4
    }
}

extension ShoppingData {
    init(from realm: RealmShoppingData) {
        title = realm.title
        link = realm.link
        image = realm.image
        mallName = realm.mallName
        lprice = realm.lprice
        hprice = realm.hprice
        productID = realm.productID
        productType = realm.productType
        brand = realm.brand
        maker = realm.maker
        category1 = realm.category1
        category2 = realm.category2
        category3 = realm.category3
        category4 = realm.category4
    }
    
    func convertToRealm() -> RealmShoppingData {
        return .init(
            title: title,
            link: link,
            image: image,
            mallName: mallName,
            lprice: lprice,
            hprice: hprice,
            productID: productID,
            productType: productType,
            brand: brand,
            maker: maker,
            category1: category1,
            category2: category2,
            category3: category3,
            category4: category4
        )
    }
}
