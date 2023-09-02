//
//  FetchFavoriteMovieListUseCase.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import RxSwift

protocol FetchFavoriteMovieListUseCaseProtocol {
    func execute() -> Observable<[Movie]>
}

final class FetchFavoriteMovieListUseCase : FetchFavoriteMovieListUseCaseProtocol{
    
    private let service: CoreDataServiceProtocol
    
    init(service: CoreDataServiceProtocol = AppDelegate.sharedAppDelegate.coreDataService) {
        self.service = service
    }
    
    func execute() -> Observable<[Movie]>{
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        let result : Observable<[MovieManagedObject]> = service.fetch(
            sortDescriptors: [sortDescriptor],
            predicate: nil
        )
        return result.map({ $0.map({
            $0.toDomain()
        }) })
    }
    
}
