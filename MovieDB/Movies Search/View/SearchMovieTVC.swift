//
//  SearchMovieTVC.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import UIKit

class SearchMovieTVC: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     //MARK:- Setup search cell
    func setupCell(list:SearchMovies){
        self.movieName.text = list.title
        let date = convertDateFormater(list.release_date ?? "")
        self.releaseDate.text = date
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
