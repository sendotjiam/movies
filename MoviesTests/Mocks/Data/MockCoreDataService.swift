//
//  MockCoreDataService.swift
//  MoviesTests
//
//  Created by Sendo Tjiam on 03/09/23.
//

import Foundation
import RxSwift
import CoreData
@testable import Movies

final class MockCoreDataService {

    private lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "Model")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init() {}
    
}

extension MockCoreDataService: CoreDataServiceProtocol {
    func fetch<T>(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate?) -> Observable<[T]> where T : NSManagedObject {
        return Observable.create({ [weak self] observer in
            guard let self else {
                observer.onError(BaseErrors.noSelfError)
                return Disposables.create()
            }
            let context = self.context
            context.performAndWait {
                let request = NSFetchRequest<T>(entityName: String(describing: T.self))
                request.sortDescriptors = sortDescriptors
                request.predicate = predicate
                let result = (try? context.fetch(request)) ?? []
                observer.onNext((result))
            }
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func save() -> Observable<Void> {
        return Observable.create({ [weak self] observer in
            guard let self else {
                observer.onError(BaseErrors.noSelfError)
                return Disposables.create()
            }
            let context = self.context
            context.performAndWait {
                if context.hasChanges {
                    try? context.save()
                }
                observer.onNext(())
            }
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func delete(_ object: NSManagedObject) -> Observable<Void> {
        return Observable.create({ [weak self] observer in
            guard let self else {
                observer.onError(BaseErrors.noSelfError)
                return Disposables.create()
            }
            let context = self.context
            context.performAndWait {
                context.delete(object)
                observer.onNext(())
            }
            observer.onCompleted()
            return Disposables.create()
        })
    }
}
