//
//  DetailViewModel.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import Foundation

// MARK: - Delegate methods to notify about response status
protocol DetailViewModelOutput : class{
    func startAnimating()
    func stopAnimating()
    func onresult()
    func onLoadSynopsis(with details: MovieDetailModel)
    func onLoadCredits(with details: CreditsModel)
    func onLoadSimilarMovies(with details: [MovieList])
    func onFailure(failure: String)
}

class DetailViewModel: NSObject {
    
      //MARK:- Properties
    weak var delegate: DetailViewModelOutput?
    var cast : [CastModel] = []
    var crew : [CrewModel] = []
    var similarMovies : [MovieList] = []
     var webServices : WebService
    
    init(apiService: WebService = WebService()) {
            self.webServices = apiService
    }
    
    //MARK:- Fetch movie details from api
    func getMovieDetails(parameters:[String:Any]){
        delegate?.startAnimating()
        let dispatchGroup = DispatchGroup()
        
        //MARK:- Movie synopsis network call
        dispatchGroup.enter()
        webServices.fetchResponse(endPoint: .movieDetail, withMethod: .get, forParamters: parameters,pageNo: 0) { [weak self] (response:Result<MovieDetailModel,ApiError>) in
            switch response{
            case .failure(let error):
                self?.delegate?.onFailure(failure: error.errorDescription)
                dispatchGroup.leave()
            case .success(let resp):
                self?.delegate?.onLoadSynopsis(with: resp)
                dispatchGroup.leave()
            }
        }
        
        //MARK:- Movie credits network call
        dispatchGroup.enter()
        WebService().fetchResponse(endPoint: .credits, withMethod: .get, forParamters: parameters,pageNo: 0) { [weak self] (response:Result<CreditsModel,ApiError>) in
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
        
       //MARK:- Similar movies network call
        dispatchGroup.enter()
        WebService().fetchResponse(endPoint: .similar, withMethod: .get, forParamters: parameters,pageNo: 1) { [weak self] (response:Result<MovieListModel,ApiError>) in
            switch response{
            case .failure(let error):
                self?.delegate?.onFailure(failure: error.errorDescription)
                dispatchGroup.leave()
            case .success(let resp):
                self?.similarMovies += resp.results
                self?.delegate?.onLoadSimilarMovies(with: resp.results)
                dispatchGroup.leave()
            }
        }
        
        //Finish
        dispatchGroup.notify(queue: .main) {
            self.delegate?.stopAnimating()
            self.delegate?.onresult()
        }
    }
    
}

