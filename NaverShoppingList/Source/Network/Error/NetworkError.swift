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

/*
 serverResponseError
검색 API 쇼핑 검색의 주요 오류 코드는 다음과 같습니다.

네이버 검색 API의 쇼핑 검색에서 발생할 수 있는 오류 코드와 그에 대한 메시지, 설명은 아래와 같습니다.

- SE01: Incorrect query request (잘못된 쿼리요청입니다.) - API 요청 URL의 프로토콜, 파라미터 등에 오류가 있는지 확인합니다.
- SE02: Invalid display value (부적절한 display 값입니다.) - display 파라미터의 값이 허용 범위의 값(1~100)인지 확인합니다.
- SE03: Invalid start value (부적절한 start 값입니다.) - start 파라미터의 값이 허용 범위의 값(1~1000)인지 확인합니다.
- SE04: Invalid sort value (부적절한 sort 값입니다.) - sort 파라미터의 값에 오타가 있는지 확인합니다.
- SE06: Malformed encoding (잘못된 형식의 인코딩입니다.) - 검색어를 UTF-8로 인코딩합니다.
- SE05: Invalid search api (존재하지 않는 검색 api 입니다.) - API 요청 URL에 오타가 있는지 확인합니다.
- SE99: System Error (시스템 에러) - 서버 내부에 오류가 발생했습니다. "https://developers.naver.com/forum"에 오류를 신고해 주십시오.
*/
