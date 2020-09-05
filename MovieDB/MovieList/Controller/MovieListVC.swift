//
//  MovieListVC.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import UIKit

class MovieListVC: UIViewController {

    @IBOutlet weak var tblMovieList: UITableView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var viewModel = MovieListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfigurations()
        // Do any additional setup after loading the view.
    }
    
    func initialConfigurations(){
        self.tblMovieList.register(UINib(nibName: "MovieListTVC", bundle: nil), forCellReuseIdentifier: "MovieListTVC")
        viewModel.delegate = self
        viewModel.getMovieList(page: 1)
    }
    
    @IBAction func proccedToSearchAction(_ sender: UIBarButtonItem) {
        let dest = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchMoviesVC") as! SearchMoviesVC
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 129/255, green: 187/255, blue: 49/255, alpha: 1)
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.style = .plain
        self.navigationController?.pushViewController(dest, animated: true)
    }
    

}

extension MovieListVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListTVC", for: indexPath) as! MovieListTVC
        cell.delegate = self
        cell.setupCell(movieData: (viewModel.movieList[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (((viewModel.movieList.count) - 1) == indexPath.row) && ((viewModel.pageNo) < (viewModel.totalpages)){
            viewModel.getMovieList(page: (viewModel.pageNo) + 1)
         }
    }
    
}

extension MovieListVC : MovieListViewModelOutput,MovieDetailAction{
    func proccedToDetail(id: Int) {
        let dest = UIStoryboard(name: "MovieDetails", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        dest.movieId = id
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 129/255, green: 187/255, blue: 49/255, alpha: 1)
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.style = .plain
        self.navigationController?.pushViewController(dest, animated: true)
    }
    
    func startAnimating() {
        DispatchQueue.main.async{
            self.activityIndicator.startAnimating()
       }
     }
     
     func stopAnimating() {
         DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
     }
    
    func onresult(with list: [MovieList], pageNo: Int, totalPages: Int) {
        if list.count == 0 {
            MovieAlertVC.shared.presentAlertController(title: "Opps", message: ResponseError.noMatchigResults.errorDescription ?? "", completionHandler: nil)
            }
        DispatchQueue.main.async {
            self.tblMovieList.reloadData()
         }
    }
    
    func onFailure(failure: String) {
        MovieAlertVC.shared.presentAlertController(title: "Failed", message: failure, completionHandler: nil)
    }
    
    
}
