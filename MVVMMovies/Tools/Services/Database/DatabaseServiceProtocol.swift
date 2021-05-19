//
//  DatabaseServiceProtocol.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 17.05.2021.
//

import CoreData
import Foundation

protocol DatabaseServiceProtocol {
    func performSave(_ block: (NSManagedObjectContext) -> Void)
    func executeFetchRequest<T>(_ request: NSFetchRequest<T>) -> [T]?
}
