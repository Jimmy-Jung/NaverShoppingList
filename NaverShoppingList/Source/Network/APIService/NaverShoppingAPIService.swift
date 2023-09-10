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
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard display <= 100 else { return .failure(.networkingError(.display)) }
        guard start <= 100 else { return .failure(.networkingError(.start)) }
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "query", value: encodedQuery))
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
    
    private func requestWithHttpHeader(url: URL, httpMethod: HttpMethod) -> URLRequest{
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.addValue(APIKEY.ClientID, forHTTPHeaderField: APIKEY.ClientID_Header)
        urlRequest.addValue(APIKEY.ClientSecret, forHTTPHeaderField: APIKEY.ClientSecret_Header)
        return urlRequest
    }
    
    private func performRequest(with urlRequest: URLRequest) async -> NaverSearchResult {
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            return parseJSON(data)
        } catch {
            return .failure(NetworkError.dataError)
        }
    }
    
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
