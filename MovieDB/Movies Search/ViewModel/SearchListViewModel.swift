//
//  SearchListViewModel.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import Foundation

protocol SearchListViewModelOutput: class {
    func onresult(with list: [SearchMovies],pageNo: Int,totalPages: Int)
    func onFailure(failure: String)
}

class SearchListViewModel: NSObject {
    
    //MARK:- Properties
    var searchList : [SearchMovies] = []
    weak var delegate: SearchListViewModelOutput?
    var pageNo = 1
    var totalpages = 0
    var storedMovies = MovieDatabase()
    var webServices : WebService
    
    init(apiService: WebService = WebService()) {
         self.webServices = apiService
     }
    
    //MARK:- Fetch search list
    func getMovieList(page:Int,query:String){
        
        // format url string
        var urlString = "\(webServices.baseURL)\(Endpoint.search.rawValue)?api_key=\(webServices.key)"
        urlString.append("&query=\(query)")
        urlString.append("&page=\(page)")
        print(urlString)

        webServices.fetchResponse(urlString: urlString, withMethod: .get) { [weak self] (response:Result<SearchListModel,ApiError>) in
           // self?.delegate?.stopAnimating()
            switch response{
            case .failure(let error):
                self?.delegate?.onFailure(failure: error.errorDescription)
            case .success(let resp):
                self?.searchList += resp.results
                self?.pageNo = resp.page ?? 0
                self?.totalpages = resp.total_pages ?? 0
                self?.delegate?.onresult(with: self?.searchList ?? [], pageNo: self?.pageNo ?? 0, totalPages: self?.totalpages ?? 0)
            }
        }
    }
    
    //MARK:- Fetch stored movie list
    func fetchStoredMovies(){
        self.storedMovies.fetchAllRecord()
        if storedMovies.movies.count != 0{
            for movie in 0...storedMovies.movies.count-1{
                let searchData = SearchMovies(id: Int(storedMovies.movies[movie].value(forKey: "id") as! String), title: storedMovies.movies[movie].value(forKey: "name") as? String, release_date: storedMovies.movies[movie].value(forKey: "releaseDate") as? String)
                self.searchList.append(searchData)
                print(self.searchList)
                if storedMovies.movies.count > 5 && self.searchList.count > 5{
                    self.storedMovies.deleteMovie(id: storedMovies.movies[0].value(forKey: "id") as? String ?? "")
                        self.searchList.remove(at: 0)
                }
            }
            self.searchList.reverse()
            self.pageNo = 1
            self.totalpages = 1
            self.delegate?.onresult(with: self.searchList, pageNo: 1, totalPages: 1)
        }
    }


}


