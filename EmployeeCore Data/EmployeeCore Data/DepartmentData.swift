//
//  DepartmentData.swift
//  EmployeeCore Data
//
//  Created by Ravi on 11/09/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DepartmentData {
    
    static let dept = DepartmentData()
    
    func addDept(dept:[String:String]){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Department", into : context) as! Department
        entity.id = dept["id"]
        entity.name = dept["name"]

        do {
            try context.save()
        }
        catch{
            context.reset()
            print("NO department Saved")
        }
        
    }
}
