//
//  SearchMoviesVC.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import UIKit

class SearchMoviesVC: UIViewController {

    @IBOutlet weak var tblSearchList: UITableView!
    
    let debouncer = Debouncer(timeInterval: 0.3)
    lazy var searchBar: UISearchBar = UISearchBar()
    var searchViewModel = SearchListViewModel()
    var movieDatabase = MovieDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchViewModel.searchList.removeAll()
        initialConfigurations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeSearchBar()
    }
    
    func initialConfigurations(){
        self.tblSearchList.register(UINib(nibName: "SearchMovieTVC", bundle: nil), forCellReuseIdentifier: "SearchMovieTVC")
        searchViewModel.delegate = self
        searchViewModel.fetchStoredMovies()
    }
    
    func addSearchBarButton() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBtnTapped(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        searchBar.delegate = self
    }
      
    
    @objc func searchBtnTapped(_ sender: UIBarButtonItem) {
        searchViewModel.searchList.removeAll()
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        searchBar.placeholder = "Search for movies"
        searchBar.showsCancelButton = true
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        searchViewModel.fetchStoredMovies()
    }
           
    @objc func searchBarTextChanged() {
        print(searchBar.searchTextField.text ?? "")
        searchViewModel.searchList.removeAll()
        if searchBar.searchTextField.text != ""{
            searchViewModel.getMovieList(page: searchViewModel.pageNo, query: searchBar.searchTextField.text ?? "")
        }else{
            self.tblSearchList.reloadData()
        }
    }
    
    func removeSearchBar() {
        self.navigationItem.titleView = nil
        searchBar.text = ""
        addSearchBarButton()
    }

}

extension SearchMoviesVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMovieTVC", for: indexPath) as! SearchMovieTVC
        cell.setupCell(list: (searchViewModel.searchList[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (((searchViewModel.searchList.count) - 1) == indexPath.row) && ((searchViewModel.pageNo) < (searchViewModel.totalpages)){
            searchViewModel.getMovieList(page: (searchViewModel.pageNo) + 1, query: self.searchBar.searchTextField.text ?? "")
         }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        removeSearchBar()
        movieDatabase.saveName(id: "\(searchViewModel.searchList[indexPath.row].id ?? 0)", name: searchViewModel.searchList[indexPath.row].title ?? "", releaseDate: searchViewModel.searchList[indexPath.row].release_date ?? "")
        let dest = UIStoryboard(name: "MovieDetails", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        dest.movieId = searchViewModel.searchList[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(dest, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}

extension SearchMoviesVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchBarTextChanged), object: nil)
//        self.perform(#selector(searchBarTextChanged), with: nil, afterDelay: 0.5)
//        setupSearchBarListeners()
        debouncer.refreshInterval()
        debouncer.completionhandler = {
            self.perform(#selector(self.searchBarTextChanged), with: nil)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        removeSearchBar()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        removeSearchBar()
    }
    
}

extension SearchMoviesVC : SearchListViewModelOutput{
    
    func onresult(with list: [SearchMovies], pageNo: Int, totalPages: Int) {
        DispatchQueue.main.async {
            self.tblSearchList.reloadData()
        }
    }
    
    func onFailure(failure: String) {
         DispatchQueue.main.async {
            MovieAlertVC.shared.presentAlertController(title: "Failed", message: failure, completionHandler: nil)
        }
    }
    
    
}
