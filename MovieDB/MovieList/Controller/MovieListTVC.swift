//
//  MovieListTVC.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import UIKit

protocol MovieDetailAction {
    func proccedToDetail(id:Int)
}

class MovieListTVC: UITableViewCell {

    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var bookNowBtn: UIButton!
    
    var delegate: MovieDetailAction?
    var movieId = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
        func setupCell(movieData:MovieList){
    //        let posterImage = URL(string: "\(WebServices.shared.imageBaseURL)\(movieData.poster_path ?? "")") ?? nil
    //        WebServices.shared.getStoredImage(from: posterImage!) { data, response, error in
    //                     guard let data = data, error == nil else { return }
    //                     DispatchQueue.main.async() {
    //                         self.posterImg.image = UIImage(data: data)
    //                     }
    //            }
            self.movieId = movieData.id ?? 0
            self.posterImg.image = UIImage(named: "")
            setImage(from: "\(WebService.shared.imageBaseURL)\(movieData.poster_path ?? "")")
            self.titleLabel.text = movieData.title
            self.releaseDateLabel.text = movieData.release_date
            self.voteCountLabel.text = "\(movieData.vote_count ?? 0)"
            self.bookNowBtn.addTarget(self, action: #selector(self.proccedToMovieDetail(_:)), for: .touchUpInside)
        }
        
        func setImage(from url: String) {
            guard let imageURL = URL(string: url) else { return }

                // just not to cause a deadlock in UI!
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }

                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.posterImg.image = image
                }
            }
        }
    
    @objc func proccedToMovieDetail(_ sender:UIButton){
        delegate?.proccedToDetail(id: movieId)
    }
}
