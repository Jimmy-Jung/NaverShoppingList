//
//  NetworkError.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/09.
//

import Foundation

enum NetworkError: Error {
case networkingError
case dataError
case parseError
case urlError
case serverResponseError
}
