//
//  MovieDetail.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation

struct MovieDetail : Equatable {
    let id : Int
    let adult : Bool
    let posterPath : String
    let originalLanguage : String
    let overview : String
    let popularity : Float
    let releaseDate : String?
    let title : String
    let backdropPath : String
    let homepage : String
    let tagline : String
    let voteAverage : Float
    let voteCount : Int
    let budget : Int
}
