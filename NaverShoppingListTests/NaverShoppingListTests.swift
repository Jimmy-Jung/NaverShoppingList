//
//  NaverShoppingListTests.swift
//  NaverShoppingListTests
//
//  Created by 정준영 on 2023/09/09.
//

import XCTest
@testable import NaverShoppingList

final class NaverShoppingAPIServiceTests: XCTestCase {
    
    var sut: NaverShoppingAPIService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NaverShoppingAPIService()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testFetchSearchData_WhenValidQuery_ShouldReturnSuccess() async throws {
        // given
        let query = "iPhone"
        let expectedItemCount = 30
        
        // when
        let result = await sut.fetchSearchData(query: query)
        
        // then
        switch result {
        case .success(let data):
            XCTAssertEqual(data.display, expectedItemCount)
        case .failure(let error):
            XCTFail("Unexpected error: \(error.errorDescription)")
        }
    }
    
    func testFetchSearchData_WhenEmptyQuery_ShouldReturnFailure() async throws {
        // given
        let query = ""
        
        // when
        let result = await sut.fetchSearchData(query: query)
        
        // then
        switch result {
        case .success:
            XCTFail("Expected error but got success")
        case .failure(let error):
            XCTAssertEqual(error.errorDescription, QueryError.query.errorDescription)
        }
    }
    func testFetchSearchData_WhenInvalidDisplay_ShouldReturnFailure() async throws {
        // given
        let query = "iPhone"
        let display = 101
        
        // when
        let result = await sut.fetchSearchData(query: query, display: display)
        
        // then
        switch result {
        case .success:
            XCTFail("Expected error but got success")
        case .failure(let error):
            XCTAssertEqual(error.errorDescription, QueryError.display.errorDescription)
        }
    }
    
    func testFetchSearchData_WhenInvalidStart_ShouldReturnFailure() async throws {
        // given
        let query = "iPhone"
        let start = 1001
        
        // when
        let result = await sut.fetchSearchData(query: query, start: start)
        
        // then
        switch result {
        case .success:
            XCTFail("Expected error but got success")
        case .failure(let error):
            XCTAssertEqual(error.errorDescription, QueryError.start.errorDescription)
        }
    }
}
