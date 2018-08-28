//
//  CustomViewController.swift
//  Demo2
//
//  Created by Ravi on 28/08/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    var name : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "LogIn Successfull  " + name!
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
