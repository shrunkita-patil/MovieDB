//
//  MovieDatabase.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MovieDatabase {
    var movies = [NSManagedObject]()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK:- Save object to store
    func saveName(id: String, name: String , releaseDate: String) {
        
        let managedContext = appDelegate.persistentContainer.viewContext
        DispatchQueue.global(qos: .background).async {
            // Delete the object if already present
            self.deleteMovie(id: id)
            managedContext.perform {
                let movie = Movie(context: managedContext)
                    movie.id = id
                    movie.name = name
                    movie.releaseDate = releaseDate
                //Save to persitsent store
                 do {
                     try managedContext.save()
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
               }
          }
        }
        
    //MARK:- fetch objects from store
    func fetchAllRecord()
    {
        let managedContext = appDelegate.persistentContainer.viewContext
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = managedContext
        privateContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
            do {
                movies = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            }
            catch let error {
                print(error)
            }
        }
    }
    
    //MARK:- Delete object from store
    func deleteMovie(id: String)
    {
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        fetchRequest.returnsObjectsAsFaults = false
        managedContext.perform {
            do{
                let fetchResults = try managedContext.fetch(fetchRequest)
                if fetchResults.first == nil{
                    return
                }
                managedContext.delete(fetchResults.first as! NSManagedObject)
                do {
                    try managedContext.save()
                } catch  let error {
                    print(error)
                }
            }
            catch let error {
                 print(error)
            }
        }
    }

}
