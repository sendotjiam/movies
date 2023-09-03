//
//  AddFavoriteUseCaseTests.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import XCTest
import RxSwift
import RxBlocking
import CoreData
@testable import Movies

final class AddFavoriteUseCaseTests: XCTestCase {
    
    private var useCase: AddFavoriteUseCaseProtocol!
    private var service: MockCoreDataService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        service = MockCoreDataService()
        useCase = AddFavoriteUseCase(service: service)
    }
    
    func test_AddFavorite() {
//        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: MovieManagedObject.self), in: service.context)
//        else {
//            return
//        }
//        let model = Movie(id: 123, posterPath: "poster_path", releaseDate: "2020-10-10", title: "Insidious 3", popularity: 777, originalLanguage: "english")
//        let newItem = NSManagedObject(entity: entity, insertInto: service.context)
//        newItem.setValue(model.id, forKey: "id")
//        newItem.setValue(model.title, forKey: "title")
//        newItem.setValue(model.posterPath, forKey: "posterPath")
//        newItem.setValue(model.originalLanguage, forKey: "originalLanguage")
//        newItem.setValue(model.popularity, forKey: "popularity")
//        newItem.setValue(model.releaseDate, forKey: "releaseDate")
//        newItem.setValue(Date(), forKey: "timestamp")
//        _ = service.save()
//
//        let request = NSFetchRequest<MovieManagedObject>(entityName: String(describing: MovieManagedObject.self))
//        let predicate = NSPredicate(format: "id == %@", String(model.id))
//        request.predicate = predicate
//        request.fetchLimit = 1
//        let filtered = (try? service.context.fetch(request)) ?? []
//        XCTAssertEqual(filtered.first?.toDomain(), model)
    }
}
