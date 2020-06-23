//
//  MovieServicesTests.swift
//  FoodSearchDemo
//
//  Created by mac on 6/23/20.
//  Copyright © 2020 mac. All rights reserved.
//

import XCTest
@testable import FoodSearchDemo

class FoodSearchServiceTests: XCTestCase {

    typealias responseHandler = (Result<SearchModel, ApiError>)->Void
    var jsonData = "{\"hits\":[{\"recipe\":{\"label\": \"Chicken Vesuvio\",\"source\": \"Serious Eats\"}}]}".data(using: .utf8)
    let httpResponse = HTTPURLResponse(url: URL(string: "https://api.edamam.com/search?q=chicken&app_id=89193820&app_key=b0c4f8afaa13f79ee3219775e0d90d23")!, statusCode: 200, httpVersion: nil, headerFields: nil)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetWithExpectedURLHostAndPath() {
        let mockUrlSession = MockURLSession(data: nil,urlResponse: nil,err: nil)
        let networkManger = SearchNetworkManger(mockUrlSession)
        let parameter = ["from":"\(0)","to":"\(10)","q":"chicken"]
        networkManger.searchFood(by:parameter) { (_) in
            
        }
        XCTAssertEqual(mockUrlSession.cachedUrl?.host, "api.edamam.com")
        XCTAssertEqual(mockUrlSession.cachedUrl?.path, "/search")

    }
    
    func testGetServicesSuccessReturnsTags() {
        
        let mockUrlSession = MockURLSession(data: jsonData,urlResponse: httpResponse,err: nil)
        
        let networkManger = SearchNetworkManger(mockUrlSession)

        var searchModel:SearchModel?
        let searchExpectation = expectation(description: "food")
        let parameter = ["from":"\(0)","to":"\(10)","q":"chicken"]
        networkManger.searchFood(by: parameter) { (result) in
            switch result{
            case .success(let model):
                searchModel = model
                searchExpectation.fulfill()
             case .failure(let _):
                searchExpectation.fulfill()

            }
        }
        
        waitForExpectations(timeout: 10) { (err) in
            XCTAssertNotNil(searchModel?.hits)
            XCTAssertEqual(searchModel?.hits?.first?.recipe?.label,"Chicken Vesuvio")
        }

    }
    func testGetTagsInvalidJSONReturnsError() {
            jsonData = "[{\"t\"}]".data(using: .utf8)
           
           let mockUrlSession = MockURLSession(data: jsonData,urlResponse: httpResponse,err: nil)
           
           let networkManger = SearchNetworkManger(mockUrlSession)
           let errorExpectation = expectation(description: "error")
           var errorResponse: ApiError?
        let parameter = ["from":"\(0)","to":"\(10)","q":"chicken"]
        networkManger.searchFood(by: parameter) { (result) in
            switch result{
            case .failure(let err):
                errorResponse = err
                errorExpectation.fulfill()
            default:
                break
            }
        }
           waitForExpectations(timeout: 10) { (error) in
               XCTAssertNotNil(errorResponse)
           }
       }
}
