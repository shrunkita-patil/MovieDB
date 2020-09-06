//
//  MovieListViewModel.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import Foundation

// MARK: - Delegate methods to notify about response status
protocol MovieListViewModelOutput {
    func startAnimating()
    func stopAnimating()
    func onresult(with list: [MovieList],pageNo: Int,totalPages: Int)
    func onFailure(failure: String)
}

class MovieListViewModel {
    
    // MARK: - Properties
    var movieList : [MovieList] = []
    var delegate: MovieListViewModelOutput?
    var pageNo = 1
    var totalpages = 0
    
    // MARK: - Method to fetch movie list
    func getMovieList(page:Int){
        delegate?.startAnimating()
        WebService().fetchResponse(endPoint: .playing, withMethod: .get, forParamters: nil,pageNo: page) { [weak self] (response:Result<MovieListModel,ApiError>, data) in
            self?.delegate?.stopAnimating()
            switch response{
            case .failure(let error):
                self?.delegate?.onFailure(failure: error.errorDescription)
            case .success(let resp):
                self?.movieList += resp.results
                self?.pageNo = resp.page ?? 0
                self?.totalpages = resp.total_pages ?? 0
                self?.delegate?.onresult(with: self?.movieList ?? [], pageNo: self?.pageNo ?? 0, totalPages: self?.totalpages ?? 0)
            }
        }
    }
}



