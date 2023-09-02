//
//  AddFavoriteUseCase.swift
//  Movies
//
//  Created by Sendo Tjiam on 02/09/23.
//

import Foundation
import CoreData
import RxSwift

protocol AddFavoriteUseCaseProtocol {
    func execute(model: Movie) -> Observable<Void>
}

final class AddFavoriteUseCase : AddFavoriteUseCaseProtocol{
    
    private let service: CoreDataServiceProtocol
    
    init(service: CoreDataServiceProtocol = AppDelegate.sharedAppDelegate.coreDataService) {
        self.service = service
    }
    
    func execute(model: Movie) -> Observable<Void>{
        let request = NSFetchRequest<MovieManagedObject>(entityName: String(describing: MovieManagedObject.self))
        let predicate = NSPredicate(format: "id == %@", String(model.id))
        request.predicate = predicate
        request.fetchLimit = 1
        let filtered = (try? service.context.fetch(request)) ?? []
        if filtered.isEmpty {
            guard let entity = NSEntityDescription.entity(forEntityName: "MovieManagedObject", in: service.context) else {
                return Observable.create({ observer in
                    observer.onError(BaseErrors.anyError)
                    return Disposables.create()
                })
            }
            let newItem = NSManagedObject(entity: entity, insertInto: service.context)
            newItem.setValue(model.id, forKey: "id")
            newItem.setValue(model.title, forKey: "title")
            newItem.setValue(model.posterPath, forKey: "posterPath")
            newItem.setValue(model.originalLanguage, forKey: "originalLanguage")
            newItem.setValue(model.popularity, forKey: "popularity")
            newItem.setValue(model.releaseDate, forKey: "releaseDate")
            newItem.setValue(Date(), forKey: "timestamp")
            let result : Observable<Void> = service.save()
            return result
        } else {
            return Observable.create({ observer in
                observer.onError(BaseErrors.notEmptyDataError)
                return Disposables.create()
            })
        }
    }
    
}
