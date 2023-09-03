//
//  DetailViewModelTests.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Movies

final class DetailViewModelTests: XCTestCase {

    private var sut: DetailViewModelProtocol!
    private var getUseCase: MockGetMovieUseCase!
    private var addUseCase: MockAddFavoriteUseCase!
    private let bag = DisposeBag()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    func test_OnViewDidLoad_Succeed() {
        getUseCase = MockGetMovieUseCase(mockType: .success)
        sut = DetailViewModel(with: getUseCase, id: 123)
        let movie = MovieDetail(id: 123, adult: false, posterPath: "poster_path", originalLanguage: "english", overview: "overview", popularity: 777, releaseDate: "2020-10-10", title: "Insidious 3", backdropPath: "backdrop_path", homepage: "homepage", tagline: "taglin", voteAverage: 7.8, voteCount: 888, budget: 1000)
        getUseCase.getMovieReturnValue = .just(movie)
        sut.onViewDidLoad()
        let result = sut.displayData
        XCTAssertEqual(result, movie)
    }
    
    func test_OnViewDidLoad_Failed() {
        getUseCase = MockGetMovieUseCase(mockType: .fail)
        sut = DetailViewModel(with: getUseCase, id: 123)
        sut.movieDetailSubject.subscribe(onError: { error in
            XCTAssertEqual(error as! BaseErrors, BaseErrors.anyError)
        }).disposed(by: bag)
        sut.onViewDidLoad()
    }
    
    func test_AddToFavorite_Succeed() {
        // Given
        addUseCase = MockAddFavoriteUseCase(mockType: .success)
        sut = DetailViewModel(addFavoriteUseCase: addUseCase, id: 123)
        addUseCase.addFavoriteReturnValue = .just(())
        sut.displayData = MovieDetail(id: 123, adult: false, posterPath: "poster_path", originalLanguage: "english", overview: "overview", popularity: 777, releaseDate: "2020-10-10", title: "Insidious 3", backdropPath: "backdrop_path", homepage: "homepage", tagline: "tagline", voteAverage: 7.8, voteCount: 888, budget: 1000)
        // When
        let expectation = expectation(description: "Success add to favorite")
        sut.addFavoriteSubject.subscribe(onNext: { _ in
            // Then
            XCTAssert(true)
            expectation.fulfill()
        }).disposed(by: bag)
        sut.addToFavorite()
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_AddToFavorite_Failed() {
        // Given
        addUseCase = MockAddFavoriteUseCase(mockType: .fail)
        sut = DetailViewModel(addFavoriteUseCase: addUseCase, id: 123)
        sut.displayData = MovieDetail(id: 123, adult: false, posterPath: "poster_path", originalLanguage: "english", overview: "overview", popularity: 777, releaseDate: "2020-10-10", title: "Insidious 3", backdropPath: "backdrop_path", homepage: "homepage", tagline: "tagline", voteAverage: 7.8, voteCount: 888, budget: 1000)
        // When
        let expectation = expectation(description: "Failed add to favorite")
        sut.addFavoriteSubject.subscribe(onError: { error in
            // Then
            XCTAssertEqual(error as! BaseErrors, BaseErrors.anyError)
            expectation.fulfill()
        }).disposed(by: bag)
        sut.addToFavorite()
        wait(for: [expectation], timeout: 10.0)
    }
}
