//
//  FavoriteViewModelTests.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Movies

final class FavoritesViewModelTests: XCTestCase {
    
    private var sut: FavoritesViewModelProtocol!
    private var fetchUseCase: MockFetchFavoriteMovieListUseCase!
    private var deleteUseCase: MockDeleteFavoriteUseCase!
    private let bag = DisposeBag()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    func test_OnViewDidLoad_LoadSucceed() {
        // Given
        let fetchUseCase = MockFetchFavoriteMovieListUseCase(mockType: .success)
        let deleteUseCase = MockDeleteFavoriteUseCase(mockType: .fail)
        sut = FavoritesViewModel(fetchUseCase: fetchUseCase, deleteUseCase: deleteUseCase)
        let movieList = [
            Movie(id: 123, posterPath: "poster_path", releaseDate: "2020-10-10", title: "Insidious 3", popularity: 777, originalLanguage: "english")
        ]
        fetchUseCase.fetchFavoriteMovieListReturnValue = .just(movieList)
        // When
        let expectation = expectation(description: "Success load data")
        sut.movieListSubject.subscribe(onNext: { _ in
            // Then
            // Assume there are no items in local, so viewmodel just compose nothing
            XCTAssert(true)
            expectation.fulfill()
        }).disposed(by: bag)
        sut.onViewDidLoad()
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_OnViewDidLoad_LoadFailed() {
        // Given
        let fetchUseCase = MockFetchFavoriteMovieListUseCase(mockType: .fail)
        let deleteUseCase = MockDeleteFavoriteUseCase(mockType: .fail)
        sut = FavoritesViewModel(fetchUseCase: fetchUseCase, deleteUseCase: deleteUseCase)
        let movieList = [
            Movie(id: 123, posterPath: "poster_path", releaseDate: "2020-10-10", title: "Insidious 3", popularity: 777, originalLanguage: "english")
        ]
        fetchUseCase.fetchFavoriteMovieListReturnValue = .just(movieList)
        // When
        let expectation = expectation(description: "Failed load data")
        sut.movieListSubject.subscribe(onError: { error in
            // Then
            XCTAssertEqual(error as! BaseErrors, BaseErrors.emptyDataError)
            expectation.fulfill()
        }).disposed(by: bag)
        sut.onViewDidLoad()
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    func test_OnViewDidLoad_GetDisplayDataSucceed() {
        let fetchUseCase = MockFetchFavoriteMovieListUseCase(mockType: .success)
        let deleteUseCase = MockDeleteFavoriteUseCase(mockType: .fail)
        sut = FavoritesViewModel(fetchUseCase: fetchUseCase, deleteUseCase: deleteUseCase)
        let movieList = [
            Movie(id: 123, posterPath: "poster_path", releaseDate: "2020-10-10", title: "Insidious 3", popularity: 777, originalLanguage: "english")
        ]
        fetchUseCase.fetchFavoriteMovieListReturnValue = .just(movieList)
        sut.onViewDidLoad()
        XCTAssertEqual(sut.displayData, movieList)
    }
    
    func test_OnViewDidLoad_GetDisplayDataFailed() {
        let fetchUseCase = MockFetchFavoriteMovieListUseCase(mockType: .fail)
        let deleteUseCase = MockDeleteFavoriteUseCase(mockType: .fail)
        sut = FavoritesViewModel(fetchUseCase: fetchUseCase, deleteUseCase: deleteUseCase)
        sut.onViewDidLoad()
        XCTAssert(sut.displayData.isEmpty)
    }
    
    func test_Delete_Succeed() {
        // Given
        let fetchUseCase = MockFetchFavoriteMovieListUseCase(mockType: .success)
        let deleteUseCase = MockDeleteFavoriteUseCase(mockType: .success)
        sut = FavoritesViewModel(fetchUseCase: fetchUseCase, deleteUseCase: deleteUseCase)
        let movieList = [
            Movie(id: 123, posterPath: "poster_path", releaseDate: "2020-10-10", title: "Insidious 3", popularity: 777, originalLanguage: "english")
        ]
        fetchUseCase.fetchFavoriteMovieListReturnValue = .just(movieList)
        deleteUseCase.deleteFavoriteReturnValue = .just(())
        // When
        let expectation = expectation(description: "Success delete movie")
        sut.movieListSubject.subscribe(onNext: { _ in
            // Then
            XCTAssert(true)
            expectation.fulfill()
        }).disposed(by: bag)
        sut.delete(by: 123)
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_Delete_Failed() {
        // Given
        let fetchUseCase = MockFetchFavoriteMovieListUseCase(mockType: .fail)
        let deleteUseCase = MockDeleteFavoriteUseCase(mockType: .fail)
        sut = FavoritesViewModel(fetchUseCase: fetchUseCase, deleteUseCase: deleteUseCase)
        // When
        let expectation = expectation(description: "Failed delete movie")
        sut.movieListSubject.subscribe(onError: { error in
            // Then
            XCTAssertEqual(error as! BaseErrors, BaseErrors.anyError)
            expectation.fulfill()
        }).disposed(by: bag)
        sut.delete(by: 123)
        wait(for: [expectation], timeout: 10.0)
    }
}
