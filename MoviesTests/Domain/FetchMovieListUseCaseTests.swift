//
//  FetchMovieListUseCaseTests.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Movies

final class FetchMovieListUseCaseTests: XCTestCase {
    
    private var useCase: FetchMovieListUseCaseProtocol!
    private var repository: MockMovieRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        repository = MockMovieRepository()
        useCase = FetchMovieListUseCase(repository: repository)
    }
    
    func test_FetchMovieList() {
        let movieResponseModel = MovieResponseModel(id: 1234, posterPath: "poster_path", originalLanguage: "english", popularity: 777, releaseDate: "2020-10-10", title: "Insidious 3")
        let movieListResponseModel = MovieListResponseModel(page: 1, results: [
            movieResponseModel
        ])
        let movieModel = movieResponseModel.toDomain()
        repository.fetchMovieListReturnValue = .just(movieListResponseModel)
        let result = useCase.execute(page: 1).map({
            return $0.first
        })
        XCTAssertEqual(try result.toBlocking().first(), movieModel)
    }
}
