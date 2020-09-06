//
//  Extensions.swift
//  MovieDB
//
//  Created by Riken Shah on 06/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func setupRadiusAndShadow(shadowColor: UIColor,cornerRadius:CGFloat = 10,shadowRadius:CGFloat = 2,shadowWidth:Int = 3,shadowHeight:Int = 3,shadowOpacity:Float = 1){
        // Make it card-like
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
    }
}


