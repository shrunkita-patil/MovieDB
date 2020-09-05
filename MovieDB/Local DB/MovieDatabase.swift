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
    
    func saveName(id: String, name: String , releaseDate: String) {
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        deleteMovie(id: id)
        
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
        
    func fetchAllRecord()
    {
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
                
        do {
            movies = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
        }
        catch let error {
            print(error)
        }
        
    }
    
    func deleteMovie(id: String)
    {
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let fetchResults = try managedContext.fetch(fetchRequest)
            if fetchResults.first == nil{
                return
            }
            managedContext.delete(fetchResults.first as! NSManagedObject)
            do {
                try managedContext.save()
            } catch {
                print("Delete error")
            }
        }
        catch
        {
             print("Delete main error")
        }
    }

}
