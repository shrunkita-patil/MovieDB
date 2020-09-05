//
//  MovieAlertVC.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import UIKit

class MovieAlertVC: UIAlertController {

    static let shared = MovieAlertVC(title: "Movies", message: nil, preferredStyle: .alert)
     var actionAfterDismiss: (()->Void)!
     var appdelegate = UIApplication.shared.delegate as! AppDelegate

     override func viewDidLoad() {
         super.viewDidLoad()
         
         // MARK: - Alert Ok Action
         let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
             guard self.actionAfterDismiss != nil else {
                 return
             }
             self.actionAfterDismiss()
         }
         addAction(okAction)
         // Do any additional setup after loading the view.
     }
     
     // MARK: - Present Alert Message
     func presentAlertController(title: String = "Movies", message: String, completionHandler: (()->Void)?) {
         self.title = title
         self.message = message
         actionAfterDismiss = completionHandler
         UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: nil)
     }

}
