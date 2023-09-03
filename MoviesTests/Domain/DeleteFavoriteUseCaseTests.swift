//
//  DeleteFavoriteUseCaseTests.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import XCTest
import RxSwift
import RxBlocking
import CoreData
@testable import Movies

final class DeleteFavoriteUseCaseTests: XCTestCase {
    
    private var useCase: DeleteFavoriteUseCaseProtocol!
    private var service: MockCoreDataService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        service = MockCoreDataService()
        useCase = DeleteFavoriteUseCase(service: service)
    }
    
    func test_DeleteFavorite() {
//        let request = NSFetchRequest<MovieManagedObject>(entityName: String(describing: MovieManagedObject.self))
//        let predicate = NSPredicate(format: "id == %@", "123")
//        request.predicate = predicate
//        request.fetchLimit = 1
//        let result = (try? service.context.fetch(request)) ?? []
//        guard let object = result.first else {
//            return
//        }
//        _ = service.delete(object)
    }
}
