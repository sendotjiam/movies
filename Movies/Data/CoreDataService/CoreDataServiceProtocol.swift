//
//  CoreDataServiceProtocol.swift
//  Movies
//
//  Created by Sendo Tjiam on 02/09/23.
//

import Foundation
import CoreData
import RxSwift

protocol CoreDataServiceProtocol {
    var context: NSManagedObjectContext { get }
    
    func fetch<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate?) -> Observable<[T]>
    func save() -> Observable<Void>
    func delete(_ object: NSManagedObject) -> Observable<Void>
}
