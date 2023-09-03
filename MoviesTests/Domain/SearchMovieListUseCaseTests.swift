//
//  SearchMovieListUseCaseTests.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Movies

final class SearchMovieListUseCaseTests: XCTestCase {

    private var useCase: SearchMovieListUseCaseProtocol!
    private var repository: MockMovieRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        repository = MockMovieRepository()
        useCase = SearchMovieListUseCase(repository: repository)
    }
    
    func test_SearchMovieList() {
        let movieResponseModel = MovieResponseModel(id: 1234, posterPath: "poster_path", originalLanguage: "english", popularity: 777, releaseDate: "2020-10-10", title: "Insidious 3")
        let movieListResponseModel = MovieListResponseModel(page: 1, results: [
            movieResponseModel
        ])
        let movieModel = [movieResponseModel.toDomain()]
        repository.searchMovieListReturnValue = .just(movieListResponseModel)
        let result = useCase.execute(keyword: "Insidious 3", page: 1)
        XCTAssertEqual(try result.toBlocking().first(), movieModel)
    }

}
