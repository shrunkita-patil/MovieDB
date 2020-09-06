//
//  MovieListViewModelTest.swift
//  MovieDBTests
//
//  Created by Riken Shah on 06/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import XCTest
@testable import MovieDB

class MovieListViewModelTest: XCTestCase {
    
    var sut: MovieListViewModel!
    var apiServices: WebService!
    
    override func setUp() {
          super.setUp()
          apiServices = WebService()
          sut = MovieListViewModel(apiService: apiServices)
      }
      
      override func tearDown() {
          sut = nil
          apiServices = nil
          super.tearDown()
      }
    
    func testMovieViewModel() {
        sut.getMovieList(page: 1)
           // Assert
        XCTAssert((apiServices != nil))
       }
    
    func testFetchResponsefail() {
        
        // Given a failed fetch with a certain failure
        
        sut.getMovieList(page: 1)
        
        apiServices.fetchFail(error: error )
        
        // Sut should display predefined error message
        XCTAssertEqual( sut.alertMessage, error.rawValue )
        
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
