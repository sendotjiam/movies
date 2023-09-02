//
//  MovieDetailResponseModel.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation

struct MovieDetailResponseModel : Decodable {
    let id : Int
    let adult : Bool
    let posterPath : String?
    let originalLanguage : String
    let overview : String
    let popularity : Float
    let releaseDate : String?
    let title : String
    let backdropPath : String?
    let homepage : String
    let genres : [GenresResponseModel]
    let tagline : String
    let voteAverage : Float
    let voteCount : Int
    let budget : Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case adult
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case overview
        case popularity
        case releaseDate = "release_date"
        case title
        case backdropPath = "backdrop_path"
        case homepage
        case genres
        case tagline
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case budget = "budget"
    }
    
    func toDomain() -> MovieDetail {
        MovieDetail(id: id, adult: adult, posterPath: posterPath ?? "", originalLanguage: originalLanguage, overview: overview, popularity: popularity, releaseDate: releaseDate, title: title, backdropPath: backdropPath ?? "", homepage: homepage, tagline: tagline, voteAverage: voteAverage, voteCount: voteCount, budget: budget)
    }
}

struct GenresResponseModel : Decodable {
    let id : Int
    let name : String
}
