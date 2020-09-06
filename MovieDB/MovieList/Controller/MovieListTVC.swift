//
//  MovieListTVC.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import UIKit
import Kingfisher

protocol MovieDetailAction {
    func proccedToDetail(id:Int)
}

class MovieListTVC: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var bookNowBtn: UIButton!
    
    //MARK:- Properties
    var delegate: MovieDetailAction?
    var movieId = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
//        self.bookNowBtn.layer.borderColor = UIColor.init(named: "002D51")?.cgColor
//        self.bookNowBtn.layer.borderWidth = 1
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Setup Movie list details
        func setupCell(movieData:MovieList){
            self.movieId = movieData.id ?? 0
             self.posterImg.kf.setImage(with: URL(string: "\(WebService().imageBaseURL)\(movieData.poster_path ?? "")"), placeholder: #imageLiteral(resourceName: "movie-poster"), options: nil, progressBlock: nil)
            self.titleLabel.text = movieData.title
            let date = convertDateFormater(movieData.release_date ?? "")
            self.releaseDateLabel.text = date
            self.voteCountLabel.text = "\(movieData.vote_count ?? 0)"
            self.bookNowBtn.addTarget(self, action: #selector(self.proccedToMovieDetail(_:)), for: .touchUpInside)
        }
        
    //MARK:- Add action to book movie
    @objc func proccedToMovieDetail(_ sender:UIButton){
        delegate?.proccedToDetail(id: movieId)
    }
    
    //MARK:- Add shadow to parent view
    func setupShadow(){
        containerView.setupRadiusAndShadow(shadowColor: UIColor.lightGray
            ,cornerRadius: 0, shadowRadius: 3, shadowWidth: 3, shadowHeight: 0, shadowOpacity: 1)
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
