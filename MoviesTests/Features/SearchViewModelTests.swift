//
//  SearchViewModelTests.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Movies

final class SearchViewModelTest: XCTestCase {

    private var sut: SearchViewModelProtocol!
    private var useCase: MockSearchMovieListUseCase!
    private let bag = DisposeBag()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    func test_OnSearch_Succeed() {
        useCase = MockSearchMovieListUseCase(mockType: .success)
        sut = SearchViewModel(with: useCase)
        let movieList = [
            Movie(id: 123, posterPath: "poster_path", releaseDate: "2020-10-10", title: "Insidious 3", popularity: 777, originalLanguage: "english")
        ]
        useCase.searchMovieListReturnValue = .just(movieList)
        sut.onSearch(keyword: "Insidious 3")
        let result = sut.displayData
        XCTAssertEqual(result, movieList)
    }
    
    func test_OnSearch_Failed() {
        useCase = MockSearchMovieListUseCase(mockType: .fail)
        sut = SearchViewModel(with: useCase)
        sut.movieListSubject.subscribe(onError: { error in
            XCTAssertEqual(error as! BaseErrors, BaseErrors.emptyDataError)
        }).disposed(by: bag)
        sut.onSearch(keyword: "Insidious 3")
    }
}

