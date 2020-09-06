//
//  CreditsCVCell.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import UIKit
import Kingfisher

class CreditsCVCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var castImg: UIImageView!
    @IBOutlet weak var castName: UILabel!
    @IBOutlet weak var characterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Setup Cast cell
    func setupCastCell(cast: CastModel){
        self.castImg.kf.setImage(with: URL(string: "\(WebService.shared.imageBaseURL)\(cast.profile_path ?? "")"), placeholder: #imageLiteral(resourceName: "Male_Profile_Placeholder"), options: nil, progressBlock: nil)
        self.castName.text = cast.name
        self.characterName.text = cast.character
    }
    
    // MARK: - Setup crew cell
    func setupCrewCell(crew: CrewModel){
        self.castImg.kf.setImage(with: URL(string: "\(WebService.shared.imageBaseURL)\(crew.profile_path ?? "")"), placeholder: #imageLiteral(resourceName: "Male_Profile_Placeholder"), options: nil, progressBlock: nil)
        self.castName.text = crew.name
        self.characterName.text = crew.job
    }
    
}
