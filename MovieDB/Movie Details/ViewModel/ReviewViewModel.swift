//
//  ReviewViewModel.swift
//  MovieDB
//
//  Created by Riken Shah on 06/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import Foundation

// MARK: - Delegate methods to notify about response status
protocol ReviewModelOutput: class {
    func startAnimating()
    func stopAnimating()
    func onLoadReviews(with details: [UserReview])
    func onFailure(failure: String)
}

class ReviewViewModel: NSObject {
    
    // MARK: - Properties
    weak var reviewDelegate: ReviewModelOutput?
    var reviews : [UserReview] = []
    var pageNo = Int()
    var totalPage = Int()
    var webServices : WebService
    
    init(apiService: WebService = WebService()) {
            self.webServices = apiService
    }
    
    // MARK: - Method to fetch reviews
    func getMovieReviews(parameters:[String:Any],pageNo:Int){
        
        var urlString = "\(webServices.baseURL)/movie"
            for eachKey in parameters.keys {
                urlString.append("/\(parameters[eachKey]!)")
            }
        urlString.append("\(Endpoint.reviews.rawValue)")
        urlString.append("?api_key=\(webServices.key)")
        urlString.append("&page=\(pageNo)")
        print("Url string : \(urlString)")
        
        webServices.fetchResponse(urlString: urlString, withMethod: .get) { [weak self] (response:Result<ReviewsModel,ApiError>) in
              switch response{
              case .failure(let error):
                  self?.reviewDelegate?.onFailure(failure: error.errorDescription)
              case .success(let resp):
                  self?.reviews += resp.results
                  self?.reviewDelegate?.onLoadReviews(with: resp.results)
              }
          }
      }
}
