//
//  GetMovieListUseCaseTests.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Movies

final class GetMovieUseCaseTests: XCTestCase {

    private var useCase: GetMovieUseCaseProtocol!
    private var repository: MockMovieRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        repository = MockMovieRepository()
        useCase = GetMovieUseCase(repository: repository)
    }
    
    func test_SearchMovieList() {
        let movieDetailResponseModel = MovieDetailResponseModel(id: 1234, adult: false, posterPath: "poster_path", originalLanguage: "english", overview: "lorem ipsum", popularity: 777, releaseDate: "2020-10-10", title: "Insidious 3", backdropPath: "backdrop_path", homepage: "webpage link", genres: [GenresResponseModel(id: 1, name: "horror")], tagline: "tagline", voteAverage: 7.9, voteCount: 1000, budget: 1000000)
        let movieDetailModel = movieDetailResponseModel.toDomain()
        repository.getMovieReturnValue = .just(movieDetailResponseModel)
        let result = useCase.execute(id: 1234)
        XCTAssertEqual(try result.toBlocking().first(), movieDetailModel)
    }

}
