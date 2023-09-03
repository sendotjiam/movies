//
//  HomeViewModelTests.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Movies

final class HomeViewModelTests: XCTestCase {
    
    private var sut: HomeViewModelProtocol!
    private var useCase: MockFetchMovieListUseCase!
    private let bag = DisposeBag()

    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    func test_OnViewDidLoad_Succeed() {
        useCase = MockFetchMovieListUseCase(mockType: .success)
        sut = HomeViewModel(with: useCase)
        let movieList = [
            Movie(id: 123, posterPath: "poster_path", releaseDate: "2020-10-10", title: "Insidious 3", popularity: 777, originalLanguage: "english")
        ]
        useCase.fetchMovieListReturnValue = .just(movieList)
        sut.onViewDidLoad()
        let result = sut.displayData
        XCTAssertEqual(result, movieList)
    }
    
    func test_OnViewDidLoad_Failed() {
        useCase = MockFetchMovieListUseCase(mockType: .fail)
        sut = HomeViewModel(with: useCase)
        sut.movieListSubject.subscribe(onError: { error in
            XCTAssertEqual(error as! BaseErrors, BaseErrors.anyError)
        }).disposed(by: bag)
        sut.onViewDidLoad()
    }
}
