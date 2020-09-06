//
//  MovieDBTests.swift
//  MovieDBTests
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import XCTest
@testable import MovieDB

class MovieDBTests: XCTestCase {
    
    let params = ["id":315064] // testing purpose
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK:- Test movie list
    func testMovieList(){
        let expect = XCTestExpectation(description: "callback")
        WebService.shared.fetchResponse(endPoint: .playing, withMethod: .get, forParamters: nil,pageNo: 0) { (response:Result<MovieListModel,ApiError>, data) in
            expect.fulfill()
            switch response{
            case .failure(let error):
                XCTAssertNil("\(error)")
            case .success(let resp):
                XCTAssertNotNil(resp.results)
            }
        }
            wait(for: [expect], timeout: 3.1)
    }
    
    //MARK:- Test movie synopsis
    func testMovieSynopsis(){
         let expect = XCTestExpectation(description: "callback")
        //MARK:- Movie synopsis network call
        WebService.shared.fetchResponse(endPoint: .movieDetail, withMethod: .get, forParamters: params,pageNo: 1) { (response:Result<MovieDetailModel,ApiError>, data) in
            expect.fulfill()
            switch response{
            case .failure(let error):
                XCTAssertNil("\(error)")
            case .success(let resp):
                XCTAssertNotNil(resp.title)
            }
        }
         wait(for: [expect], timeout: 3.1)
    }
    
    //MARK:- Test movie credits
    func testMovieCredits(){
         let expect = XCTestExpectation(description: "callback")
        //MARK:- Movie synopsis network call
        WebService.shared.fetchResponse(endPoint: .credits, withMethod: .get, forParamters: params,pageNo: 1) { (response:Result<CreditsModel,ApiError>, data) in
            expect.fulfill()
            switch response{
            case .failure(let error):
                XCTAssertNil("\(error)")
            case .success(let resp):
                XCTAssertNotNil(resp.cast)
                XCTAssertNotNil(resp.crew)
            }
        }
         wait(for: [expect], timeout: 3.1)
    }
    
    //MARK:- Test similar movie list
   func testMovieSimilarMovies(){
           let expect = XCTestExpectation(description: "callback")
          //MARK:- Movie synopsis network call
          WebService.shared.fetchResponse(endPoint: .similar, withMethod: .get, forParamters: params,pageNo: 1) { (response:Result<MovieListModel,ApiError>, data) in
              expect.fulfill()
              switch response{
              case .failure(let error):
                  XCTAssertNil("\(error)")
              case .success(let resp):
                XCTAssertNotNil(resp)
              }
          }
           wait(for: [expect], timeout: 3.1)
      }

    //MARK:- Test search movies
    func testMovieSearch(){
          let expect = XCTestExpectation(description: "callback")
        WebService.shared.fetchResponse(endPoint: .search, withMethod: .get, forParamters: nil,searchQuery:"te", pageNo: 1) { (response:Result<SearchListModel,ApiError>, data) in
            expect.fulfill()
             switch response{
             case .failure(let error):
                 XCTAssertNil("\(error)")
             case .success(let resp):
                XCTAssertNotNil(resp)
             }
         }
        wait(for: [expect], timeout: 3.1)
    }

}
