//
//  DeleteVC.swift
//  EmployeeCore Data
//
//  Created by Ravi on 06/09/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class UpdateVC:UIViewController,UITextFieldDelegate{
    var name = String()
    var id = String()
    @IBOutlet weak var nametextField: UITextField!
    @IBOutlet weak var idLabelField: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var deptLabelField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        nametextField.delegate = self
        addressTextField.delegate = self
    }
    
    
    
    func fetch(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let pred = NSPredicate(format: "id == %@", id,name)
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        request.predicate = pred
        
    
        do{
            let obj = try context.fetch(request)
            if(obj.count>0){
                idLabelField.text = obj[0].id
                nametextField.text = obj[0].name
                addressTextField.text = obj[0].address
                deptLabelField.text = obj[0].worksFor?.name
            }
        }
        catch{
            print ("Error")
        }
        
    }
    
    @IBAction func onClickDelete(_ sender: Any){
        delete()
        idLabelField.text = ""
        nametextField.text = ""
        addressTextField.text = ""
        deptLabelField.text = ""
    }

    func delete(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let pred = NSPredicate(format: "id == %@", id)
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        request.predicate = pred
        do{
            let obj = try context.fetch(request)
            for item in obj{
            context.delete(item)
            }
            try context.save()
            let alert = UIAlertController(title: "DELETED", message: "Record Updated", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present( alert , animated: true)
        }
            
        catch{
            print("Error Deleting or Saving")
        }
        
    }
    
    
    @IBAction func onClickUpdate(_ sender: Any) {
        let id = idLabelField.text
        if(nametextField.text == "" || addressTextField.text == "")
        {
            let alert = UIAlertController(title: "Alert",message: "None of the fields should be left blank",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present( alert , animated: true)
            return
        }
        update(id:id!)
        
    }
    
    func update(id:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        let predicate = NSPredicate(format: "id == %@", id )
        request.predicate = predicate
        do{
            let obj = try context.fetch(request)
            let objectUpdate = obj[0] as NSManagedObject
            objectUpdate.setValue(nametextField.text!, forKey: "name")
            objectUpdate.setValue(addressTextField.text!, forKey: "address")
            try context.save()
            let alert = UIAlertController(title: "Updated", message: "Record Updated", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present( alert , animated: true)
            } catch  {
            print("Couldn't Update")
            }
        }
    }
    
   
    

