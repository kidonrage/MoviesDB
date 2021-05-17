//
//  DBMovie+CoreDataProperties.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 17.05.2021.
//
//

import CoreData
import Foundation

/// Экземпляр Movie для CoreData
public extension DBMovie {
    @nonobjc class func fetchRequest() -> NSFetchRequest<DBMovie> {
        NSFetchRequest<DBMovie>(entityName: "DBMovie")
    }

    @NSManaged var id: Int64
    @NSManaged var overview: String?
    @NSManaged var posterPath: String?
    @NSManaged var title: String?
    @NSManaged var releaseDate: String?
}

extension DBMovie: Identifiable {}
