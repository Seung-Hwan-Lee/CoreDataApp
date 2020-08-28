//
//  ManagedPerson+CoreDataProperties.swift
//  CoreDataApp
//
//  Created by Thomas on 2020/08/28.
//  Copyright © 2020 Thomas. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedPerson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedPerson> {
        return NSFetchRequest<ManagedPerson>(entityName: "Person")
    }

    @NSManaged public var name: String?

}
