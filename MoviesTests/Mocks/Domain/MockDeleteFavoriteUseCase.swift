//
//  MockDeleteFavoriteUseCase.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import Foundation
import RxSwift
@testable import Movies

final class MockDeleteFavoriteUseCase: DeleteFavoriteUseCaseProtocol {
    
    private let mockType: MockType
    
    init(mockType: MockType) {
        self.mockType = mockType
    }
    
    var deleteFavoriteReturnValue : Observable<Void>!
    func execute(by id: Int) -> Observable<Void> {
        switch (mockType) {
        case .success:
            return deleteFavoriteReturnValue
        case .fail:
            return Observable.create({ observer in
                observer.onError(BaseErrors.anyError)
                return Disposables.create()
            })
        }
    }
    
}
