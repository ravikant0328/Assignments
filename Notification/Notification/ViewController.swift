//
//  ViewController.swift
//  Notification
//
//  Created by Ravi on 24/08/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var goBack: UIButton!
    var initialLoad : Bool = true
    override func viewDidLoad(){
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(Cricket(notification:)) , name: .Cricket, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Football(notification:)) , name: .Football, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Volleyball(notification:)), name: .Volleyball, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if(initialLoad){
            goBack.isEnabled = false
            initialLoad = false
        }
        else{
            goBack.isEnabled = true
        }
    }
    func todisplay(mystrings:String){
        let mystring:String!=mystrings
        let multipleattribute:[NSAttributedStringKey:Any]=[
            NSAttributedStringKey.font:UIFont(name:"Zapfino",size:20)!,
            NSAttributedStringKey.backgroundColor:UIColor.orange,
            NSAttributedStringKey.strokeWidth:2,
            NSAttributedStringKey.foregroundColor:UIColor.red]
        let mystring2=NSAttributedString(string:mystring,attributes:multipleattribute)
        label.attributedText=mystring2
    }
    @objc func Cricket(notification:Notification){
        todisplay(mystrings: "Cricket")
        img.image=#imageLiteral(resourceName: "Cricket.jpeg")
    }
    @objc func Football(notification:Notification){
        todisplay(mystrings: "Football")
        img.image=#imageLiteral(resourceName: "Football.jpeg")
    }
    @objc func Volleyball(notification:Notification){
        todisplay(mystrings: "Volleyball")
        img.image=#imageLiteral(resourceName: "Volleyball.jpeg")
    }
    
    @IBAction func buttonclick(_ sender: Any){
        let secondvc=self.storyboard?.instantiateViewController(withIdentifier:"OtherViewController") as! OtherViewController
        self.navigationController?.pushViewController(secondvc, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension Notification.Name{
    static let Cricket=Notification.Name("Cricket")
    static let Football=Notification.Name("Football")
    static let Volleyball=Notification.Name("Volleyball")
}
