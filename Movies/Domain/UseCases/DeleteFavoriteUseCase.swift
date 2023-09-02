//
//  DeleteFavoriteUseCase.swift
//  Movies
//
//  Created by Sendo Tjiam on 02/09/23.
//

import Foundation
import RxSwift
import CoreData

protocol DeleteFavoriteUseCaseProtocol {
    func execute(by id: Int) -> Observable<Void>
}

final class DeleteFavoriteUseCase: DeleteFavoriteUseCaseProtocol {
    
    private let service: CoreDataServiceProtocol
    
    init(service: CoreDataServiceProtocol = AppDelegate.sharedAppDelegate.coreDataService) {
        self.service = service
    }
    
    func execute(by id: Int) -> Observable<Void> {
        let request = NSFetchRequest<MovieManagedObject>(entityName: String(describing: MovieManagedObject.self))
        let predicate = NSPredicate(format: "id == %@", "\(id)")
        request.predicate = predicate
        request.fetchLimit = 1
        let result = (try? service.context.fetch(request)) ?? []
        guard let object = result.first else {
            return Observable.create({ observer in
                observer.onError(BaseErrors.anyError)
                return Disposables.create()
            })
        }
        return service.delete(object)
    }
    
}
