//
//  SearchListModel.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import Foundation

struct SearchListModel: Codable {
    let results: [SearchMovies]
    let total_pages: Int?
    let page: Int?
    
    enum CodingKeys: String, CodingKey {
        case results
        case total_pages
        case page
    }
}

struct SearchMovies: Codable {
    let id: Int?
    let title: String?
    let release_date: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case release_date
    }
}
