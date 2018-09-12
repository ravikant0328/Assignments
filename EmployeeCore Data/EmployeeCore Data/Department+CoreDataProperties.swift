//
//  Department+CoreDataProperties.swift
//  EmployeeCore Data
//
//  Created by Ravi on 11/09/18.
//  Copyright © 2018 Ravi. All rights reserved.
//
//

import Foundation
import CoreData


extension Department {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Department> {
        return NSFetchRequest<Department>(entityName: "Department")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var contains: NSSet?

}

// MARK: Generated accessors for contains
extension Department {

    @objc(addContainsObject:)
    @NSManaged public func addToContains(_ value: Employee)

    @objc(removeContainsObject:)
    @NSManaged public func removeFromContains(_ value: Employee)

    @objc(addContains:)
    @NSManaged public func addToContains(_ values: NSSet)

    @objc(removeContains:)
    @NSManaged public func removeFromContains(_ values: NSSet)

}
