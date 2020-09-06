//
//  MovieDetailVC.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import UIKit

class MovieDetailVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieStatus: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var collectionCast: UICollectionView!
    @IBOutlet weak var collectionCrew: UICollectionView!
    @IBOutlet weak var collectionSimilarMovies: UICollectionView!
    @IBOutlet weak var likes: UILabel!
    
    //MARK:- Properties
    var viewModel = DetailViewModel()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var movieId = Int()
    
    //MARK:- Load synopsis details
    var synopsis: MovieDetailModel? {
        didSet {
            DispatchQueue.main.async {
                 // load all data
                self.posterImg.kf.setImage(with: URL(string: "\(WebService().imageBaseURL)\(self.synopsis?.poster_path ?? "")"), placeholder: #imageLiteral(resourceName: "movie-poster"), options: nil, progressBlock: nil)
                self.movieName.text = self.synopsis?.title
                self.movieStatus.text = self.synopsis?.status
                self.movieDescription.text = self.synopsis?.overview
                let date = self.convertDateFormater(self.synopsis?.release_date ?? "")
                self.releaseDate.text = date
                self.title = self.synopsis?.title
                self.likes.text = "\(self.synopsis?.vote_count ?? 0)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfigurations()
        setupActivityIndicator()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- initial settings
    func initialConfigurations(){
        viewModel.delegate = self
        self.collectionCast.register(UINib(nibName:"CreditsCVCell", bundle: nil), forCellWithReuseIdentifier: "CreditsCVCell")
        self.collectionCrew.register(UINib(nibName:"CreditsCVCell", bundle: nil), forCellWithReuseIdentifier: "CreditsCVCell")
        self.collectionSimilarMovies.register(UINib(nibName:"SimilarMoviesCVC", bundle: nil), forCellWithReuseIdentifier: "SimilarMoviesCVC")
        let params = ["id":self.movieId]
        viewModel.getMovieDetails(parameters: params)
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

    //MARK:- Method to expand text
    @IBAction func proccedToExpandTextAction(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "angle-down"){
            self.movieDescription.numberOfLines = 0
            sender.setImage(#imageLiteral(resourceName: "angle-up"), for: .normal)
        }else{
            self.movieDescription.numberOfLines = 5
            sender.setImage(#imageLiteral(resourceName: "angle-down"), for: .normal)
        }
    }
    
    //MARK:- Action to read reviews
    @IBAction func proccedToReadReviews(_ sender: UITapGestureRecognizer) {
        let dest = UIStoryboard(name: "MovieDetails", bundle: nil).instantiateViewController(withIdentifier: "MovieReviewsVC") as! MovieReviewsVC
        dest.movieId = self.synopsis?.id ?? 0
        self.navigationController?.pushViewController(dest, animated: true)
    }
    
    //MARK:- Method to Convert date
     func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
    }

    
}

//MARK:- Collection view delegate and dataSource methods
extension MovieDetailVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionCast{
            return viewModel.cast.count
        }else if collectionView == collectionCrew{
            return viewModel.crew.count
        }else{
            return viewModel.similarMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionCast{
             let cell = collectionCast.dequeueReusableCell(withReuseIdentifier: "CreditsCVCell", for: indexPath) as! CreditsCVCell
            cell.setupCastCell(cast: (viewModel.cast[indexPath.row]))
            return cell
        }else if collectionView == collectionCrew{
            let cell = collectionCrew.dequeueReusableCell(withReuseIdentifier: "CreditsCVCell", for: indexPath) as! CreditsCVCell
            cell.setupCrewCell(crew: (viewModel.crew[indexPath.row]))
            return cell
        }else{
            let cell = collectionSimilarMovies.dequeueReusableCell(withReuseIdentifier: "SimilarMoviesCVC", for: indexPath) as! SimilarMoviesCVC
            cell.setupCell(movie: (viewModel.similarMovies[indexPath.row]))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
       {
         if collectionView == collectionCast{
           return CGSize(width: collectionView.frame.size.width/3 - 10, height: collectionView.frame.size.height)
         }
         else if collectionView == collectionCrew{
            return CGSize(width: self.collectionCrew.frame.size.width/3 - 10, height: self.collectionCrew.frame.size.height)
         }else{
             return CGSize(width: self.collectionSimilarMovies.frame.size.width/3 - 10, height: self.collectionSimilarMovies.frame.size.height)
        }
       }
       
}

//MARK:- delegate methods
extension MovieDetailVC : DetailViewModelOutput{
    
    //MARK:- Animate loader while fetching data from api
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
    
    //MARK:- Fetch synopsis response from network call
    func onLoadSynopsis(with details: MovieDetailModel) {
        self.synopsis = details
    }
    
    //MARK:- Fetch credits response from network call
    func onLoadCredits(with details: CreditsModel) {
        if details.cast.count != 0{
            DispatchQueue.main.async {
                self.collectionCast.reloadData()
                self.collectionCast.layoutIfNeeded()
            }
         }
        if details.crew.count != 0{
            DispatchQueue.main.async {
                self.collectionCrew.reloadData()
                self.collectionCast.layoutIfNeeded()
            }
        }
    }
    
    //MARK:- Fetch similar movies response from network call
    func onLoadSimilarMovies(with details: [MovieList]) {
        if details.count != 0{
            DispatchQueue.main.async {
                self.collectionSimilarMovies.reloadData()
            }
        }else{
            DispatchQueue.main.async {
               // self.collectionSimilarMovies.cons
            }
        }
    }
    
    //MARK:- Display error if network call fails
    func onFailure(failure: String) {
        DispatchQueue.main.async {
            MovieAlertVC.shared.presentAlertController(title: "Failed", message: failure, completionHandler: nil)
        }
    }
    
}
