//
//  RealmShoppingData.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import Foundation
import RealmSwift

final class RealmShoppingData: Object {
    
    @Persisted var title: String
    @Persisted var link: String
    @Persisted var image: String
    @Persisted var mallName: String
    @Persisted var lprice: String
    @Persisted var hprice: String
    @Persisted var productID: String
    @Persisted var productType: String
    @Persisted var brand: String
    @Persisted var maker: String
    @Persisted var category1: String
    @Persisted var category2: String
    @Persisted var category3: String
    @Persisted var category4: String
    
    convenience init(title: String, link: String, image: String, mallName: String, lprice: String, hprice: String, productID: String, productType: String, brand: String, maker: String, category1: String, category2: String, category3: String, category4: String) {
        self.init()
        self.title = title
        self.link = link
        self.image = image
        self.mallName = mallName
        self.lprice = lprice
        self.hprice = hprice
        self.productID = productID
        self.productType = productType
        self.brand = brand
        self.maker = maker
        self.category1 = category1
        self.category2 = category2
        self.category3 = category3
        self.category4 = category4
    }
}
