//
//  ReviewsTVC.swift
//  MovieDB
//
//  Created by Riken Shah on 06/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import UIKit

class ReviewsTVC: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userReview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
      //MARK:- Setup review cell
    func setupData(review: UserReview){
        self.userName.text = review.author?.capitalized
        self.userReview.text = review.content
    }
}
