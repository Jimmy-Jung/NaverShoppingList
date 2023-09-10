//
//  NaverShoppingAPIService.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/09.
//

import Foundation

struct NaverShoppingAPIService {
    
    typealias NaverEndPoint = NaverShoppingEndPoint
    typealias NaverSearchResult = Result<ShoppingResult, NetworkError>
    
    /// 네이버 API를 통해 검색 결과를 가져오는 메소드
    func fetchSearchData(
        query: String,
        display: Int = 30,
        start: Int = 1,
        sort: NaverEndPoint.Sort = .sim,
        filter: NaverEndPoint.Filter? = nil,
        exclude: [NaverEndPoint.Exclude]? = nil
    ) async -> NaverSearchResult {
        var urlComponents = URLComponents(string: NaverEndPoint.baseURL)
        guard !query.isEmpty else { return .failure(.networkingError(.query)) }
        guard display <= 100 else { return .failure(.networkingError(.display)) }
        guard start <= 1000 else { return .failure(.networkingError(.start)) }
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "query", value: query))
        queryItems.append(URLQueryItem(name: "display", value: "\(display)"))
        queryItems.append(URLQueryItem(name: "start", value: "\(start)"))
        queryItems.append(URLQueryItem(name: "sort", value: sort.rawValue))
        if let filter { queryItems.append(URLQueryItem(name: "filter", value: filter.rawValue)) }
        if let exclude, !exclude.isEmpty ,exclude.count <= NaverEndPoint.Exclude.allCases.count {
            let excludeValue = exclude.map { "{\($0.rawValue)}" }.joined(separator: ":")
            queryItems.append(URLQueryItem(name: "exclude", value: excludeValue))
        }
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return .failure(NetworkError.urlError) }
        let urlRequest = requestWithHttpHeader(url: url, httpMethod: .get)
        return await performRequest(with: urlRequest)
    }
    
    /// HTTP 헤더를 추가하여 URLRequest를 생성하는 메소드
    private func requestWithHttpHeader(url: URL, httpMethod: HttpMethod) -> URLRequest{
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.addValue(APIKEY.ClientID, forHTTPHeaderField: APIKEY.ClientID_Header)
        urlRequest.addValue(APIKEY.ClientSecret, forHTTPHeaderField: APIKEY.ClientSecret_Header)
        return urlRequest
    }
    
    /// URLRequest를 통해 HTTP 요청을 보내고 결과를 가져오는 메소드
    private func performRequest(with urlRequest: URLRequest) async -> NaverSearchResult {
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            return parseJSON(data)
        } catch {
            return .failure(NetworkError.dataError)
        }
    }
    
    /// JSON 데이터를 파싱하는 메소드
    private func parseJSON(_ data: Data) -> NaverSearchResult {
        do {
            let naverData = try JSONDecoder().decode(ShoppingResult.self, from: data)
            return .success(naverData)
        } catch {
            if let naverErrorData = try? JSONDecoder().decode(NaverErrorResult.self, from: data) {
                return .failure(NetworkError.serverResponseError(errorCode: naverErrorData.errorCode, errorMassage: naverErrorData.errorMessage))
            } else {
                return .failure(NetworkError.parseError)
            }
        }
    }
}
