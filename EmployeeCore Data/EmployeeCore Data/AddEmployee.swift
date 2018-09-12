//
//  AddEmployee.swift
//  EmployeeCore Data
//
//  Created by Ravi on 05/09/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddEmployee: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{
   
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    var selection : Int = 0
    let myPickerData = ["iOS","Android","FrontEnd"]
    
    @IBAction func onClickSave(_ sender: Any) {
        if(nameField.text == "" || idField.text == "" || addressField.text == "")
        {
            let alert = UIAlertController(title: "Alert",message: "None of the fields should be left blank",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present( alert , animated: true)
            return
        }
        addEmpItem()
        nameField.text = ""
        idField.text = ""
        addressField.text = ""
    }
    
    func addEmpItem(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
       
        entity.name = nameField.text
        entity.id = idField.text
        entity.address = addressField.text
        entity.worksFor = departmentFetch(pickerValue:String(selection+1))
        do {
            try context.save()
            let alert = UIAlertController(title: "Congrats",message: "New Employee has been added",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present( alert , animated: true)
            
            }
        catch let error as NSError {
            debugPrint(error.userInfo)
            print("Not able to save")
            let alert = UIAlertController(title: "Warning",message: "Id must be unique",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present( alert , animated: true)
        }
        context.reset()
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return myPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myPickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selection = pickerView.selectedRow(inComponent: 0)
        print(selection)
    }
    func departmentFetch(pickerValue:String) -> Department{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Department>(entityName: "Department")
        let pred = NSPredicate(format: "id = %@", pickerValue)
        request.predicate = pred
        var result = [Department] ()
        do{
           result = try context.fetch(request)
        }
        catch{
             print("No Department Found")
        }
        return result[0]
    }
}



    

