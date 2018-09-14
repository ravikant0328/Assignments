//
//  ViewController.swift
//  EmployeeCore Data
//
//  Created by Ravi on 05/09/18.
//  Copyright © 2018 Ravi. All rights reserved.


import UIKit
import CoreData

class ViewController: UIViewController , UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listTableView: UITableView!
    @IBAction func onclickDeleteAll(_ sender: Any) {
        deleteall()
        listAllData()
    }
    
    func deleteall(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        let deleterequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        do{
            _ = try context.execute(deleterequest)
            try context.save()
        }
        catch{
            print("Error Deleting all")
        }
    }
    
    
    var id: [String] = []
    var names: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView?.register(UINib.init(nibName: String(describing: TableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: "Cell")
        self.listTableView.reloadData()
        searchBar.delegate = self
        DepartmentData.dept.addDept(dept:["id":"1","name":"iOS"])
        DepartmentData.dept.addDept(dept:["id":"2","name":"Android"])
        DepartmentData.dept.addDept(dept:["id":"3","name":"FrontEnd"])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        listAllData()
    }


    
    func listAllData(){
        names = []
        id = []
        fetch()
        self.listTableView.reloadData()
    }

    
    func fetch() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let obj = try context.fetch(request)
            
            for emp in obj {
                names.append(emp.name!)
                id.append(emp.id!)
                }
        }
        catch {
            print("Fetching error")
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func search(name:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let pred = NSPredicate(format: "name = %@", name)
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        request.predicate = pred



        do{
            let obj = try context.fetch(request)
            for emp in obj{
                names.append(emp.name!)
                id.append(emp.id!)
            }
        }
        catch{
            print ("Not Found")
        }

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        names = []
        search(name: searchBar.text!)
        self.listTableView.reloadData()
    }
    
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! TableViewCell
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let vc2 = storyboard?.instantiateViewController(withIdentifier: "Update") as! UpdateVC
       vc2.name = names[indexPath.row]
       vc2.id = id[indexPath.row]
       navigationController?.pushViewController(vc2, animated: true)
    }
}




