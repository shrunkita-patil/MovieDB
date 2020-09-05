//
//  MovieDetailVC.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import UIKit

class MovieDetailVC: UIViewController {
    
    @IBOutlet weak var collectionCast: UICollectionView!
    @IBOutlet weak var collectionCrew: UICollectionView!
    
    var viewModel = DetailViewModel()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var movieId = Int()
    
    var synopsis: MovieDetailModel? {
        didSet {
            DispatchQueue.main.async {
                // load all data
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfigurations()
        setupActivityIndicator()
        // Do any additional setup after loading the view.
    }
    
    func initialConfigurations(){
        viewModel.delegate = self
        self.collectionCast.register(UINib(nibName:"CreditsCVCell", bundle: nil), forCellWithReuseIdentifier: "CreditsCVCell")
        self.collectionCrew.register(UINib(nibName:"CreditsCVCell", bundle: nil), forCellWithReuseIdentifier: "CreditsCVCell")
        let params = ["id":self.movieId]
        viewModel.getMovieDetails(parameters: params)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        self.view.addSubview(activityIndicator)
     }

}

extension MovieDetailVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionCast{
            return viewModel.cast.count
        }else{
            return viewModel.crew.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionCast{
             let cell = collectionCast.dequeueReusableCell(withReuseIdentifier: "CreditsCVCell", for: indexPath) as! CreditsCVCell
            cell.setupCastCell(cast: (viewModel.cast[indexPath.row]))
            return cell
        }else {
            let cell = collectionCrew.dequeueReusableCell(withReuseIdentifier: "CreditsCVCell", for: indexPath) as! CreditsCVCell
            cell.setupCrewCell(crew: (viewModel.crew[indexPath.row]))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
       {
         if collectionView == collectionCast{
           return CGSize(width: self.collectionCast.frame.size.width/3 - 20, height: self.collectionCast.frame.size.height)
         }
         else{
            return CGSize(width: self.collectionCrew.frame.size.width/3 - 20, height: self.collectionCrew.frame.size.height)
        }
       }
       
}

extension MovieDetailVC : DetailViewModelOutput{
    func startAnimating() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
     }
     
     func stopAnimating() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
     }
    
    func onresult() {
        print("Fetch all api data.")
    }
    
    func onLoadSynopsis(with details: MovieDetailModel) {
        self.synopsis = details
    }
    
    func onLoadCredits(with details: CreditsModel) {
        if details.cast.count != 0{
            DispatchQueue.main.async {
                self.collectionCast.reloadData()
            }
        }else{
            DispatchQueue.main.async {
            MovieAlertVC.shared.presentAlertController(title: "Oops", message: ResponseError.noMatchigResults.errorDescription ?? "", completionHandler: nil)
            }
        }
        if details.crew.count != 0{
            DispatchQueue.main.async {
                self.collectionCrew.reloadData()
            }
        }else{
            DispatchQueue.main.async {
                MovieAlertVC.shared.presentAlertController(title: "Oops", message: ResponseError.noMatchigResults.errorDescription ?? "", completionHandler: nil)
            }
        }
    }
    
    func onFailure(failure: String) {
        DispatchQueue.main.async {
            MovieAlertVC.shared.presentAlertController(title: "Failed", message: failure, completionHandler: nil)
        }
    }
    
}
