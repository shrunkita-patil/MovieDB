//
//  MovieListModel.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import Foundation

// MARK: - Store Movie List data
struct MovieListModel: Codable {
    let results: [MovieList]
    let total_pages: Int?
    let page: Int?
    
    enum CodingKeys: String, CodingKey {
        case results
        case total_pages
        case page
    }
}

struct MovieList: Codable {
    let id: Int?
    let poster_path: String?
    let title: String?
    let release_date: String?
    var vote_count: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case poster_path
        case title
        case release_date
        case vote_count
    }
}
