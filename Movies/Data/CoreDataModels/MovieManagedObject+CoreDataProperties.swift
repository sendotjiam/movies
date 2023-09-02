//
//  MovieManagedObject+CoreDataProperties.swift
//  Movies
//
//  Created by Sendo Tjiam on 02/09/23.
//
//

import Foundation
import CoreData


extension MovieManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieManagedObject> {
        return NSFetchRequest<MovieManagedObject>(entityName: "MovieManagedObject")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var releaseDate: String?
    @NSManaged public var originalLanguage: String?
    @NSManaged public var popularity: Float

    func toDomain() -> Movie {
        Movie(id: Int(truncatingIfNeeded: id), posterPath: posterPath ?? "", releaseDate: releaseDate, title: title ?? "", popularity: popularity, originalLanguage: originalLanguage ?? "")
    }
    
}

extension MovieManagedObject : Identifiable {

}
