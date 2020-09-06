//
//  WebService.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

class WebService {
    
    // MARK: - Properties
//    static let shared = WebService()
//    fileprivate init() {}
    private let baseURL = "https://api.themoviedb.org/3" // Base url
    let key = "284ba8bcb404b3212977480790f2f6ec" // Api key
    let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    
    // MARK: - Fetch data from api
    func fetchResponse<T:Codable>(endPoint api: Endpoint, withMethod method: HTTPMethod, forParamters parameters: [String:Any]? = nil,searchQuery: String? = nil,pageNo:Int, completion: @escaping(Result<T,ApiError>) -> Void) {
        
        // Check network connection
        guard checkForNetworkConnectivity() else {
            DispatchQueue.main.async{
               MovieAlertVC.shared.presentAlertController(title: "Connection Problem", message: "Please check your internet connection!", completionHandler: nil)
            }
            return
        }
        
        var request: URLRequest!

            // Check parameters for GET method
                var urlString = "\(baseURL)/movie"
                if parameters != nil{
                    for eachKey in parameters!.keys {
                        urlString.append("/\(parameters![eachKey]!)")
                    }
                }
                urlString.append("\(api.rawValue)")
                urlString.append("?api_key=\(key)")
                print("Url string : \(urlString)")
            
                if searchQuery != nil{
                    urlString = "\(baseURL)\(api.rawValue)?api_key=\(key)"
                    urlString.append("&query=\(searchQuery!)")
                 }
            
                // check for pagination
                if pageNo != 0{
                    urlString.append("&page=\(pageNo)")
                 }
                
//        if parameters != nil{
//            for (eachKey,eachValue) in parameters! {
//                urlString.append("/\(parameters![eachKey]!)=\(parameters![eachValue as! String]!)")
//            }
//        }
        
             request = URLRequest(url: URL(string: urlString.replacingOccurrences(of: " ", with: "%20"))!)
        
        
        request.httpMethod = method.rawValue
        
        // API call with request
        URLSession.shared.dataTask(with: request) { (data, resp, err) in
            if err == nil {
                guard let data = data else { return }
                do{
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                 } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(.errorMsg(message: ResponseError.JSONSerializationFailed.errorDescription ?? "")))
               }
            } else {
                completion(.failure(.errorMsg(message: ResponseError.wrongData.errorDescription ?? "")))
            }
        }.resume()
    }

}

