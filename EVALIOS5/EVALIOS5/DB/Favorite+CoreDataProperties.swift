//
//  Favorite+CoreDataProperties.swift
//  EVALIOS5
//
//  Created by Student08 on 25/10/2023.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var addedDate: Date?

}

extension Favorite : Identifiable {

}
