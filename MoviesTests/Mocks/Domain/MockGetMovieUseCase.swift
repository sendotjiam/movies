//
//  MockGetMovieUseCase.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import Foundation
import RxSwift
@testable import Movies

final class MockGetMovieUseCase: GetMovieUseCaseProtocol {
    
    private let mockType: MockType
    
    init(mockType: MockType) {
        self.mockType = mockType
    }
    
    var getMovieReturnValue : Observable<MovieDetail>!
    func execute(id: Int) -> Observable<MovieDetail> {
        switch (mockType) {
        case .success:
            return getMovieReturnValue
        case .fail:
            return Observable.create({ observer in
                observer.onError(BaseErrors.anyError)
                return Disposables.create()
            })
        }
    }
    
}
