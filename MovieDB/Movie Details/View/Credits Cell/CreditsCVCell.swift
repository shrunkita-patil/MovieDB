//
//  CreditsCVCell.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import UIKit

class CreditsCVCell: UICollectionViewCell {

    @IBOutlet weak var castImg: UIImageView!
    @IBOutlet weak var castName: UILabel!
    @IBOutlet weak var characterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCastCell(cast: CastModel){
        self.castImg.image = UIImage(named: "")
        setImage(from: "\(WebService.shared.imageBaseURL)\(cast.profile_path ?? "")")
        self.castName.text = cast.name
        self.characterName.text = cast.character
    }
    
    func setupCrewCell(crew: CrewModel){
        self.castImg.image = UIImage(named: "")
        setImage(from: "\(WebService.shared.imageBaseURL)\(crew.profile_path ?? "")")
        self.castName.text = crew.name
        self.characterName.text = crew.job
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                    self.castImg.image = image
            }
        }
    }
}
