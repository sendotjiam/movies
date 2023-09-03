//
//  MockFetchMovieListUseCase.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import Foundation
import RxSwift
@testable import Movies

final class MockFetchMovieListUseCase: FetchMovieListUseCaseProtocol {
    
    private let mockType: MockType
    
    init(mockType: MockType) {
        self.mockType = mockType
    }
    
    var fetchMovieListReturnValue : Observable<[Movie]>!
    func execute(page: Int) -> Observable<[Movie]> {
        switch (mockType) {
        case .success:
            return fetchMovieListReturnValue
        case .fail:
            return Observable.create({ observer in
                observer.onError(BaseErrors.anyError)
                return Disposables.create()
            })
        }
    }
    
}
