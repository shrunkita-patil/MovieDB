//
//  SearchMoviesVC.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import UIKit

class SearchMoviesVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tblSearchList: UITableView!
    
    //MARK:- Properties
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
    
    //MARK:- Initial settings
    func initialConfigurations(){
        self.tblSearchList.register(UINib(nibName: "SearchMovieTVC", bundle: nil), forCellReuseIdentifier: "SearchMovieTVC")
        self.tblSearchList.estimatedRowHeight = 90
        searchViewModel.delegate = self
        searchViewModel.fetchStoredMovies()
        self.tblSearchList.tableFooterView = UIView()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.title = "Search"
        addBackButton()
    }
    
    //MARK:- Add back to navigation
    func addBackButton(){
        let backbutton = UIButton(type: .custom)
        backbutton.setTitle("Back", for: .normal)
        backbutton.setTitleColor(UIColor.white, for: .normal)
        backbutton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
    }
    
    @objc func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Added search bar on navigation
    func addSearchBarButton() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBtnTapped(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        searchBar.delegate = self
        searchViewModel.searchList.removeAll()
        searchViewModel.fetchStoredMovies()
    }
      
    //MARK:- Action to Search bar click event
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
           
    //MARK:- Action to search text change
    @objc func searchBarTextChanged() {
        print(searchBar.searchTextField.text ?? "")
        searchViewModel.searchList.removeAll()
        if searchBar.searchTextField.text != ""{
            searchViewModel.getMovieList(page: searchViewModel.pageNo, query: searchBar.searchTextField.text ?? "")
        }else{
            searchViewModel.fetchStoredMovies()
           // self.tblSearchList.reloadData()
        }
    }
    
    //MARK:- Remove search from navigation bar
    func removeSearchBar() {
        self.navigationItem.titleView = nil
        searchBar.text = ""
        addSearchBarButton()
    }

}

//MARK:- Tableview Methods to display list
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
        movieDatabase.saveName(id: "\(searchViewModel.searchList[indexPath.row].id ?? 0)", name: searchViewModel.searchList[indexPath.row].title ?? "", releaseDate: searchViewModel.searchList[indexPath.row].release_date ?? "")
        let dest = UIStoryboard(name: "MovieDetails", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        dest.movieId = searchViewModel.searchList[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(dest, animated: true)
        removeSearchBar()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK:- Search bar deelegate methods
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

//MARK:- Network call delegate method
extension SearchMoviesVC : SearchListViewModelOutput{
    
    //MARK:- Fetch result and display changes
    func onresult(with list: [SearchMovies], pageNo: Int, totalPages: Int) {
        DispatchQueue.main.async {
            self.tblSearchList.reloadData()
        }
    }
    
    //MARK:- method to display network call failure
    func onFailure(failure: String) {
         DispatchQueue.main.async {
            MovieAlertVC.shared.presentAlertController(title: "Failed", message: failure, completionHandler: nil)
        }
    }
    
    
}
