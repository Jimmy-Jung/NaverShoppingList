//
//  LocalizedString.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import Foundation

typealias ErrorString = LocalizedString.Error
typealias NSSearchString = LocalizedString.NSSearch

enum LocalizedString {
    enum Error {
        static let networkingError = "네트워킹에 문제가 있습니다."
        static let dataError = "데이터를 불러오는데 문제가 발생했습니다."
        static let parseError = "데이터를 분석하는데 문제가 발생했습니다."
        static let urlError = "url주소가 잘못됐습니다."
        static let httpResponseError = "HTTP 요청에 실패했습니다"
        static let serverResponseError = "서버에서 데이터를 받아오는데 문제가 발생했습니다."
        static let unknownError = "알 수 없는 오류가 발생했습니다."
    }
    
    enum NSSearch {
        static let searchBarPlaceholder = "검색어를 입력해주세요"
        static let sim = "정확도"
        static let date = "날짜순"
        static let asc = "가격높은순"
        static let dsc = "가격낮은순"
    }
}
