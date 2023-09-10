//
//  NaverShoppingEndPoint.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/09.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NaverShoppingEndPoint {
    static var baseURL = "https://openapi.naver.com/v1/search/shop.json"

    enum Sort: String, CaseIterable {
        case sim
        case date
        case asc
        case dsc
    }
    
    enum Filter: String {
        case naverpay
    }
    
    /// 검색 결과에서 제외할 상품 유형
    ///
    /// exclude={option}:{option}:{option} 형태로 설정합니다(예: exclude=used:cbshop).
    /// - used: 중고
    /// - rental: 렌탈
    /// - cbshop: 해외직구, 구매대행
    enum Exclude: String, CaseIterable {
        case used
        case rental
        case cbshop
    }
    
}


