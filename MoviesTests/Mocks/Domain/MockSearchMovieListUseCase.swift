//
//  MockSearchMovieListUseCase.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import Foundation
import RxSwift
@testable import Movies

final class MockSearchMovieListUseCase: SearchMovieListUseCaseProtocol {
    
    private let mockType: MockType
    
    init(mockType: MockType) {
        self.mockType = mockType
    }
    
    var searchMovieListReturnValue : Observable<[Movie]>!
    func execute(keyword: String, page: Int) -> Observable<[Movie]> {
        switch (mockType) {
        case .success:
            return searchMovieListReturnValue
        case .fail:
            return Observable.create({ observer in
                observer.onError(BaseErrors.emptyDataError)
                return Disposables.create()
            })
        }
    }
    
}
