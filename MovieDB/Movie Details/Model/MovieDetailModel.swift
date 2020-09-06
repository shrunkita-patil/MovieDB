//
//  MovieDetailModel.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import Foundation

//MARK:- Movie Synopsis model
struct MovieDetailModel: Codable {
    let id: Int?
    let poster_path: String?
    let title: String?
    let release_date: String?
    var vote_average: Float?
    var overview: String?
    var popularity: Float?
    var status : String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case poster_path
        case title
        case release_date
        case vote_average
        case overview
        case popularity
        case status
    }
}

//MARK:- Movvie credit model
struct CreditsModel: Codable {
    let cast: [CastModel]
    let crew: [CrewModel]
    
    enum CodingKeys: String, CodingKey {
        case cast
        case crew
    }
}

//MARK:- Movie cast list model
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

//MARK:- Movie crew list model
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

//MARK:- Movie reviews model
struct ReviewsModel: Codable {
    let results: [UserReview]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct UserReview: Codable {
    let author: String?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case author
        case content
    }
}
