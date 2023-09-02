//
//  CoreDataService.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import CoreData
import RxSwift

final class CoreDataService {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init() {}
}

extension CoreDataService : CoreDataServiceProtocol {
    func fetch<T : NSManagedObject>(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate?) -> Observable<[T]> {
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

    func delete(_ object: NSManagedObject) -> Observable<Void> {
        return Observable.create({ [weak self] observer in
            guard let self else {
                observer.onError(BaseErrors.noSelfError)
                return Disposables.create()
            }
            let context = self.context
            context.performAndWait {
                context.delete(object)
                try? context.save()
                observer.onNext(())
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
}
