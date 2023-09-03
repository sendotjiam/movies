//
//  MockAddToFavoriteUseCase.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import Foundation
import RxSwift
@testable import Movies

final class MockAddFavoriteUseCase: AddFavoriteUseCaseProtocol {
    
    private let mockType: MockType
    
    init(mockType: MockType) {
        self.mockType = mockType
    }
    
    var addFavoriteReturnValue : Observable<Void>!
    func execute(model: Movie) -> Observable<Void> {
        switch (mockType) {
        case .success:
            return addFavoriteReturnValue
        case .fail:
            return Observable.create({ observer in
                observer.onError(BaseErrors.anyError)
                return Disposables.create()
            })
        }
    }
    
}

