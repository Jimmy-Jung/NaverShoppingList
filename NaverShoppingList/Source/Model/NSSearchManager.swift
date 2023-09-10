//
//  NSSearchManager.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import Foundation

protocol NSSearchProtocol: AnyObject {
    func updateShoppingList(_ list: [ShoppingData])
    func fetchShoppingList(_ list: [ShoppingData])
    func receiveError(_ errorMessage: String)
}

final class NSSearchManager {
    typealias Sort = NaverShoppingAPIService.NaverEndPoint.Sort
    private let naverShoppingAPIService = NaverShoppingAPIService()
    private var networkWorkItem: DispatchWorkItem?
    weak var delegate: NSSearchProtocol?
    private var displayCount: Int = 0
    func searchTerm(term: String, sort: Sort) {
        
        // 이전에 예약된 네트워크 요청을 취소합니다.
        networkWorkItem?.cancel()
        
        // 지연 후 새로운 네트워크 요청을 예약합니다.
        let workItem = DispatchWorkItem {
            Task { [weak self] in
                guard let self else { return }
                await callRequest(query: term, sort: sort)
            }
        }
        networkWorkItem = workItem
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + 0.3,
            execute: workItem
        )
    }
    
    func callRequest(query: String, sort: Sort) async {
        let result = await naverShoppingAPIService.fetchSearchData(query: query, sort: sort)
        switch result {
        case .success(let result):
            displayCount = result.display
            delegate?.fetchShoppingList(result.items)
        case .failure(let error):
            delegate?.receiveError(error.errorDescription)
            break
        }
    }
    
    func updateRequest(query: String, sort: Sort) async {
        let result = await naverShoppingAPIService.fetchSearchData(query: query, start: displayCount + 1,sort: sort)
        switch result {
        case .success(let result):
            displayCount += result.display
            delegate?.updateShoppingList(result.items)
        case .failure(let error):
            delegate?.receiveError(error.errorDescription)
            break
        }
    }
}
