//
//  NaverShoppingEndPoint.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/09.
//

import Foundation


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


enum NaverShoppingEndPoint {
    static var baseURL = "https://openapi.naver.com"
    static var path = "/v1/search/shop.json"

    enum Sort: String {
        case sim
        case date
        case asc
        case dsc
    }
    
    enum Filter: String {
        case naverpay
    }
    
    /// 검색 결과에서 제외할 상품 유형
    /// .exclude={option}:{option}:{option} 형태로 설정합니다(예: exclude=used:cbshop).
    /// - used: 중고
    /// - rental: 렌탈
    /// - cbshop: 해외직구, 구매대행
    enum Exclude: String, CaseIterable {
        case used
        case rental
        case cbshop
    }
    
    static func getURL(query: String, display: Int = 10, start: Int = 1, sort: Sort, filter: Filter? = nil, exclude: [Exclude]) {
        var urlComponents = URLComponents(string: baseURL + path)
        let clientID = URLQueryItem(name: "X-Naver-Client-Id", value: APIKEY.ClientID)
        let clientSecret = URLQueryItem(name: "X-Naver-Client-Secret", value: APIKEY.ClientSecret)
        guard !query.isEmpty else { return }
        guard display <= 100 else { return }
        guard start <= 100 else { return }
        urlComponents?.queryItems?.append(URLQueryItem(name: "query", value: query))
        urlComponents?.queryItems?.append(URLQueryItem(name: "display", value: "\(display)"))
        urlComponents?.queryItems?.append(URLQueryItem(name: "start", value: "\(start)"))
        urlComponents?.queryItems?.append(URLQueryItem(name: "sort", value: sort.rawValue))
        if let filter {
            urlComponents?.queryItems?.append(URLQueryItem(name: "filter", value: filter.rawValue))
        }
        guard exclude.count <= Exclude.allCases.count else { return }
        let excludeValue = exclude.map { "{\($0.rawValue)}" }.joined(separator: ":")
        urlComponents?.queryItems?.append(URLQueryItem(name: "exclude", value: excludeValue))
        
        urlComponents?.url
    }
}


