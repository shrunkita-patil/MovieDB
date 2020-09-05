//
//  DetailViewModel.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import Foundation

protocol DetailViewModelOutput {
    func startAnimating()
    func stopAnimating()
    func onresult()
    func onLoadSynopsis(with details: MovieDetailModel)
    func onLoadCredits(with details: CreditsModel)
    func onFailure(failure: String)
}

class DetailViewModel: NSObject {
    
    var delegate: DetailViewModelOutput?
    var cast : [CastModel] = []
    var crew : [CrewModel] = []
    
    func getMovieDetails(parameters:[String:Any]){
        delegate?.startAnimating()
        let dispatchGroup = DispatchGroup()
        
            //Movie Synopsis
        dispatchGroup.enter()
        WebService.shared.fetchResponse(endPoint: .movieDetail, withMethod: .get, forParamters: parameters,pageNo: 0) { [weak self] (response:Result<MovieDetailModel,ApiError>, data) in
            switch response{
            case .failure(let error):
                self?.delegate?.onFailure(failure: error.errorDescription)
                dispatchGroup.leave()
            case .success(let resp):
                self?.delegate?.onLoadSynopsis(with: resp)
                dispatchGroup.leave()
            }
        }
        
        // Movie Credits
        dispatchGroup.enter()
        WebService.shared.fetchResponse(endPoint: .credits, withMethod: .get, forParamters: parameters,pageNo: 0) { [weak self] (response:Result<CreditsModel,ApiError>, data) in
            switch response{
            case .failure(let error):
                self?.delegate?.onFailure(failure: error.errorDescription)
                dispatchGroup.leave()
            case .success(let resp):
                self?.cast += resp.cast
                self?.crew += resp.crew
                self?.delegate?.onLoadCredits(with: resp)
                dispatchGroup.leave()
            }
        }
        
//        // Similar movies
//        dispatchGroup.enter()
//        WebService.shared.fetchResponse(endPoint: .movieDetail, withMethod: .get, forParamters: nil,pageNo: 0) { [weak self] (response:Result<MovieDetailModel,ApiError>, data) in
//            switch response{
//            case .failure(let error):
//                self?.delegate?.onFailure(failure: error.errorDescription)
//                dispatchGroup.leave()
//            case .success(let resp):
//               // self?.delegate?.onresult(with: resp)
//                dispatchGroup.leave()
//            }
//        }
        
        //Finish
        dispatchGroup.notify(queue: .main) {
            self.delegate?.stopAnimating()
            self.delegate?.onresult()
        }
    }
    
}

