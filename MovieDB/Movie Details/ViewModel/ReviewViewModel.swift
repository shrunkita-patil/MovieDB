//
//  ReviewViewModel.swift
//  MovieDB
//
//  Created by Riken Shah on 06/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import Foundation

// MARK: - Delegate methods to notify about response status
protocol ReviewModelOutput {
    func startAnimating()
    func stopAnimating()
    func onLoadReviews(with details: [UserReview])
    func onFailure(failure: String)
}

class ReviewViewModel: NSObject {
    
    // MARK: - Properties
    var reviewDelegate: ReviewModelOutput?
    var reviews : [UserReview] = []
    var pageNo = Int()
    var totalPage = Int()
    
    // MARK: - Method to fetch reviews
    func getMovieReviews(parameters:[String:Any],pageNo:Int){
          WebService().fetchResponse(endPoint: .reviews, withMethod: .get, forParamters: parameters,pageNo: pageNo) { [weak self] (response:Result<ReviewsModel,ApiError>, data) in
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
