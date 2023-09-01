//
//  MovieResponseModel.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation

struct MovieListResponseModel : Decodable {
    let page : Int
    let results : [MovieResponseModel]
}

struct MovieResponseModel : Decodable {
    let id : Int
    let adult : Bool
    let posterPath : String?
    let originalLanguage : String
    let overview : String
    let popularity : Float
    let releaseDate : String?
    let title : String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case adult = "adult"
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case overview = "overview"
        case popularity = "popularity"
        case releaseDate = "release_date"
        case title = "title"
    }
    
    func toDomain() -> Movie {
        Movie(id: id, adult: adult, posterPath: posterPath ?? "", originalLanguage: originalLanguage, overview: overview, popularity: popularity, releaseDate: releaseDate, title: title)
    }
}
