//
//  Employee+CoreDataProperties.swift
//  EmployeeCore Data
//
//  Created by Ravi on 11/09/18.
//  Copyright © 2018 Ravi. All rights reserved.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var address: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var worksFor: Department?

}
