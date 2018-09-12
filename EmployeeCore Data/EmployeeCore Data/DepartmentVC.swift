//
//  DepartmentVC.swift
//  EmployeeCore Data
//
//  Created by Ravi on 11/09/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DepartmentVC : UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var deptTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deptTableView?.register(UINib.init(nibName: String(describing: TableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: "Cell")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        listAllData()
        self.deptTableView.reloadData()
        let (androidEmpName,androidEmpID) = fetchEmployeeNamefromDepartment(id:"2")
        let (iOSEmpName,iOSEmpID) = fetchEmployeeNamefromDepartment(id: "1")
        let (frontEndEmpName,frontEndEmpId) = fetchEmployeeNamefromDepartment(id: "3")
        tableViewData = [cellData(opened: false, title: "iOS", id: iOSEmpID, sectionData: iOSEmpName),
                         cellData(opened: false, title: "Android", id: androidEmpID, sectionData: androidEmpName),
                         cellData(opened: false, title: "FrontEnd", id: frontEndEmpId, sectionData: frontEndEmpName)]
    }
    
    struct cellData{
        var opened = Bool()
        var title = String()
        var id = [String]()
        var sectionData = [String]()
    }
    
    var tableViewData = [cellData]()
    
    
    var deptName = [String] ()
    var deptid: [String] = []
    
//    func listAllData() {
//        deptid = []
//        deptName = []
//        fetch()
//    }
    
    
    
//    func fetch() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let request = NSFetchRequest<Department>(entityName: "Department")
//
//        do {
//            let obj = try context.fetch(request)
//
//            for dept in obj {
//                deptName.append(dept.name!)
//                deptid.append(dept.id!)
//            }
//            print (deptName)
//            self.deptTableView.reloadData()
//        }
//        catch {
//            print("Fetching error")
//        }
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
   func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
    if tableViewData[section].opened == true{
        return tableViewData[section].sectionData.count + 1
    }else{
        return 1
    }
    }
    
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let dataIndex = indexPath.row - 1
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! TableViewCell
        if(indexPath.row == 0){
            cell.textLabel?.text = tableViewData[indexPath.section].title
            cell.backgroundColor = UIColor.cyan
            return cell
        }else{
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[dataIndex]
            cell.backgroundColor = UIColor.white
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewData[indexPath.section].opened == true {
            tableViewData[indexPath.section].opened = false
            if( indexPath.row != 0 ){
                  let vc = storyboard?.instantiateViewController(withIdentifier: "Update") as! UpdateVC
                  vc.id = (tableViewData[indexPath.section].id[indexPath.row - 1])
                  self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .middle)
                tableView.reloadData()
            }
        }else{
            tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .middle)
        }
    }
    
    
    func fetchEmployeeNamefromDepartment(id:String) -> ([String],[String]){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Department>(entityName: "Department")
        let pred = NSPredicate(format: "id = %@",id)
        request.predicate = pred
        var empObj : [Employee]
        var empName : [String] = []
        var empId : [String] = []
        do {
            let obj = try context.fetch(request)
            for dept in obj{
                print(dept.contains!.count)
                empObj = (dept.contains?.allObjects)! as! [Employee]
                for item in empObj{
                    print(item.name!)
                    empName.append(item.name!)
                    empId.append(item.id!)
                }
            }
        }
        catch {
            print("Fetching error")
        }
        return (empName,empId)
    }
    
}


