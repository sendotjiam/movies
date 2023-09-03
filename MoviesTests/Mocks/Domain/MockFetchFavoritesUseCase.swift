//
//  MockFetchFavoritesUseCase.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import Foundation
import RxSwift
@testable import Movies

final class MockFetchFavoriteMovieListUseCase: FetchFavoriteMovieListUseCaseProtocol {
    
    private let mockType: MockType
    
    init(mockType: MockType) {
        self.mockType = mockType
    }
    
    var fetchFavoriteMovieListReturnValue : Observable<[Movie]>!
    func execute() -> Observable<[Movie]> {
        switch (mockType) {
        case .success:
            return fetchFavoriteMovieListReturnValue
        case .fail:
            return Observable.create({ observer in
                observer.onError(BaseErrors.emptyDataError)
                return Disposables.create()
            })
        }
    }
    
}

