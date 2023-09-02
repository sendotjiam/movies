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
    let posterPath : String?
    let originalLanguage : String
    let popularity : Float
    let releaseDate : String?
    let title : String
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case popularity
        case releaseDate = "release_date"
        case title
    }
    
    func toDomain() -> Movie {
        Movie(id: id, posterPath: posterPath ?? "", releaseDate: releaseDate, title: title, popularity: popularity, originalLanguage: originalLanguage)
    }
}
