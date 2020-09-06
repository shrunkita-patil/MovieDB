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
    var sut : WebService?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    override func setUp() {
           super.setUp()
        sut = WebService()
       }

       override func tearDown() {
           sut = nil
           super.tearDown()
       }

    //MARK:- Test movie list
    func testMovieList(){
        let sut = self.sut!
        var urlString = "\(sut.baseURL)/movie"
        urlString.append("\(Endpoint.playing.rawValue)")
        urlString.append("?api_key=\(sut.key)")
        urlString.append("&page=1")
        let expect = XCTestExpectation(description: "callback")
        sut.fetchResponse(urlString:urlString,withMethod: .get) { (response:Result<MovieListModel,ApiError>) in
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
         let sut = self.sut!
        var urlString = "\(sut.baseURL)/movie/315064"
        urlString.append("\(Endpoint.movieDetail.rawValue)")
        urlString.append("?api_key=\(sut.key)")
         let expect = XCTestExpectation(description: "callback")
        //MARK:- Movie synopsis network call
        sut.fetchResponse(urlString:urlString,withMethod: .get) { (response:Result<MovieDetailModel,ApiError>) in
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
         let sut = self.sut!
        var urlString = "\(sut.baseURL)/movie/315064"
        urlString.append("\(Endpoint.credits.rawValue)")
        urlString.append("?api_key=\(sut.key)")
        urlString.append("&page=1")
         let expect = XCTestExpectation(description: "callback")
        //MARK:- Movie synopsis network call
        sut.fetchResponse(urlString:urlString,withMethod: .get) { (response:Result<CreditsModel,ApiError>) in
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
           let sut = self.sut!
            var urlString = "\(sut.baseURL)/movie/315064"
            urlString.append("\(Endpoint.similar.rawValue)")
            urlString.append("?api_key=\(sut.key)")
            urlString.append("&page=1")
           let expect = XCTestExpectation(description: "callback")
          //MARK:- Movie synopsis network call
          sut.fetchResponse(urlString:urlString,withMethod: .get) { (response:Result<MovieListModel,ApiError>) in
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
         let sut = self.sut!
        var urlString = "\(sut.baseURL)\(Endpoint.search.rawValue)?api_key=\(sut.key)"
        urlString.append("&query=te")
        urlString.append("&page=1")
          let expect = XCTestExpectation(description: "callback")
        sut.fetchResponse(urlString:urlString,withMethod: .get) { (response:Result<SearchListModel,ApiError>) in
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
