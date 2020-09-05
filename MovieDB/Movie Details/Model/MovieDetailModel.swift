//
//  MovieDetailModel.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import Foundation

struct MovieDetailModel: Codable {
    let id: Int?
    let poster_path: String?
    let title: String?
    let release_date: String?
    var vote_average: Float?
    var overview: String?
    var popularity: Float?
    
    enum CodingKeys: String, CodingKey {
        case id
        case poster_path
        case title
        case release_date
        case vote_average
        case overview
        case popularity
    }
}

struct CreditsModel: Codable {
    let cast: [CastModel]
    let crew: [CrewModel]
    
    enum CodingKeys: String, CodingKey {
        case cast
        case crew
    }
}

struct CastModel: Codable {
    let cast_id: Int?
    let name: String?
    let profile_path: String?
    let character: String?
    
    enum CodingKeys: String, CodingKey {
        case cast_id
        case name
        case profile_path
        case character
    }
}

struct CrewModel: Codable {
    let id: Int?
    let name: String?
    let job: String?
    let profile_path: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case job
        case profile_path
    }
}

