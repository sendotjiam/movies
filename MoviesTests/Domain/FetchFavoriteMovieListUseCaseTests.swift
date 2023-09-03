//
//  FetchFavoriteMovieListUseCaseTests.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Movies

final class FetchFavoriteMovieListUseCaseTests: XCTestCase {
    
    private var useCase: FetchFavoriteMovieListUseCaseProtocol!
    private var service: MockCoreDataService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        service = MockCoreDataService()
        useCase = FetchFavoriteMovieListUseCase(service: service)
    }
    
    func test_FetchFavoriteMovieList() {
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        let objects : Observable<[MovieManagedObject]> = service.fetch(
            sortDescriptors: [sortDescriptor],
            predicate: nil
        )
        let expectedResult = objects.map({ $0.map({
            $0.toDomain()
        }) })
        let result = useCase.execute()
        XCTAssertEqual(try result.toBlocking().first(), try expectedResult.toBlocking().first())
    }
}
