//
//  ViewController.swift
//  Demo2
//
//  Created by Ravi on 16/08/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func onTouchAction(_ sender: Any) {
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let customVC = segue.destination as! CustomViewController
        customVC.name = usernameField.text
        
    }

}
