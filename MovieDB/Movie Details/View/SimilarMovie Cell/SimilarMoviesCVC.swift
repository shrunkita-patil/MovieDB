//
//  SimilarMoviesCVC.swift
//  MovieDB
//
//  Created by Riken Shah on 06/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import UIKit

class SimilarMoviesCVC: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Setup movie cell
    func setupCell(movie: MovieList){
        self.movieName.text = movie.title
        self.moviePoster.kf.setImage(with: URL(string: "\(WebService.shared.imageBaseURL)\(movie.poster_path ?? "")"), placeholder: #imageLiteral(resourceName: "movie-poster"), options: nil, progressBlock: nil)
    }

}
