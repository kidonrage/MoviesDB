//
//  DBMovie+CoreDataProperties.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 19.05.2021.
//
//

import CoreData
import Foundation

/// Movie для сохранения в БД
public extension DBMovie {
    @nonobjc class func fetchRequest() -> NSFetchRequest<DBMovie> {
        NSFetchRequest<DBMovie>(entityName: "DBMovie")
    }

    @NSManaged var id: Int64
    @NSManaged var overview: String?
    @NSManaged var posterPath: String?
    @NSManaged var releaseDate: String?
    @NSManaged var title: String?
    @NSManaged var type: Int16
}

extension DBMovie: Identifiable {}
