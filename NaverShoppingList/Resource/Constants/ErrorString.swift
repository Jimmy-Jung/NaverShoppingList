//
//  ErrorString.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/09.
//

import Foundation

enum ErrorString {
    static let networkingError = "네트워킹에 문제가 있습니다."
    static let dataError = "데이터를 불러오는데 문제가 발생했습니다."
    static let parseError = "데이터를 분석하는데 문제가 발생했습니다."
    static let urlError = "url주소가 잘못됐습니다."
    static let httpResponseError = "HTTP 요청에 실패했습니다"
    static let serverResponseError = "서버에서 데이터를 받아오는데 문제가 발생했습니다."
    static let unknownError = "알 수 없는 오류가 발생했습니다."
}
