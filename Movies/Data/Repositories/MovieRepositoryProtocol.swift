//
//  MovieRepositoryProtocol.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import RxSwift

protocol MovieRepositoryProtocol {
    func fetchMovieList(page: Int) -> Observable<MovieListResponseModel>
    func searchMovieList(query: String, page: Int) -> Observable<MovieListResponseModel>
}

