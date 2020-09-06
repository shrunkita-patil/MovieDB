//
//  MovieReviewsVC.swift
//  MovieDB
//
//  Created by Riken Shah on 06/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import UIKit

class MovieReviewsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblReviews: UITableView!
    @IBOutlet weak var noReview: UILabel!
    
    //MARK:- Properties
    var reviewViewModel = ReviewViewModel()
    var movieId = Int()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfigurations()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Initial settings
    func initialConfigurations(){
        self.reviewViewModel.reviewDelegate = self
        let params = ["id":self.movieId]
        self.reviewViewModel.getMovieReviews(parameters: params, pageNo: 1)
        self.tblReviews.register(UINib(nibName: "ReviewsTVC", bundle: nil), forCellReuseIdentifier: "ReviewsTVC")
        self.tblReviews.estimatedRowHeight = 80
        self.tblReviews.tableFooterView = UIView()
        self.noReview.isHidden = true
        self.title = "Reviews"
        self.navigationItem.setHidesBackButton(true, animated: true)
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
    
    //MARK:- Setup indicator while loading data
    private func setupActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        self.view.addSubview(activityIndicator)
    }

}

  //MARK:- Configure tableView methods to display reviews
extension MovieReviewsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewViewModel.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTVC", for: indexPath) as! ReviewsTVC
        cell.setupData(review: (reviewViewModel.reviews[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (((reviewViewModel.reviews.count) - 1) == indexPath.row) && ((reviewViewModel.pageNo) < (reviewViewModel.totalPage)){
            let params = ["id":self.movieId]
            self.reviewViewModel.getMovieReviews(parameters: params, pageNo: reviewViewModel.pageNo + 1)
         }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK:- Methods to display data on view
extension MovieReviewsVC : ReviewModelOutput{
    
    //MARK:- Methods while Loading data
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
    
     //MARK:- Fetch data from network call
    func onLoadReviews(with details: [UserReview]) {
        if details.count == 0{
            DispatchQueue.main.async{
             self.noReview.isHidden = false
            }
            return
        }
        DispatchQueue.main.async{
         self.tblReviews.reloadData()
        }
    }
    
     //MARK:- Method to display error message
    func onFailure(failure: String) {
        DispatchQueue.main.async{
            MovieAlertVC.shared.presentAlertController(title: "Failed", message: failure, completionHandler: nil)
        }
    }
    
}
