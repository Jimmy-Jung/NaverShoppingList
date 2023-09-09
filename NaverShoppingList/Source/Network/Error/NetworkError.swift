//
//  NetworkError.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/09.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case networkingError(QueryError)
    case dataError
    case parseError
    case urlError
    case httpResponseError
    case serverResponseError(errorCode: String, errorMassage: String)
    case unknownError
    
    var errorDescription: String {
        switch self {
        case .networkingError(let queryError):
            return queryError.errorDescription
        case .dataError:
            return ErrorString.dataError
        case .parseError:
            return ErrorString.parseError
        case .urlError:
            return ErrorString.urlError
        case .httpResponseError:
            return ErrorString.httpResponseError
        case .serverResponseError(let errorCode, let errorMessage):
            return "ErrorCode: \(errorCode), ErrorMessage: \(errorMessage)"
        case .unknownError:
            return ErrorString.unknownError
        }
    }
}

enum QueryError: LocalizedError {
    case query
    case display
    case start
    case exclude

    var errorDescription: String {
        switch self {
        case .query:
            return "검색어. UTF-8로 인코딩되어야 합니다."
        case .display:
            return "한 번에 표시할 검색 결과 개수(기본값: 10, 최댓값: 100)를 초과했습니다"
        case .start:
            return "검색 시작 위치(기본값: 1, 최댓값: 1000)를 초과했습니다"
        case .exclude:
            return "exclude={option}:{option}:{option} 형태로 설정해야합니다."
        }
    }
}

