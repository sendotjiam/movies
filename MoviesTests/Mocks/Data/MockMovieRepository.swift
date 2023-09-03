//
//  MoviesRepositoryMock.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import Foundation
import RxSwift
@testable import Movies

final class MockMovieRepository : MovieRepositoryProtocol {
    
    var fetchMovieListReturnValue: Observable<MovieListResponseModel>!
    func fetchMovieList(page: Int) -> Observable<MovieListResponseModel> {
        fetchMovieListReturnValue
    }
    
    var getMovieReturnValue: Observable<MovieDetailResponseModel>!
    func getMovie(by id: Int) -> Observable<MovieDetailResponseModel> {
        getMovieReturnValue
    }
    
    var searchMovieListReturnValue: Observable<MovieListResponseModel>!
    func searchMovieList(query: String, page: Int) -> Observable<MovieListResponseModel> {
        searchMovieListReturnValue
    }
}
