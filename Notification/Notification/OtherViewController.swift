//
//  OtherViewController.swift
//  Notification
//
//  Created by Ravi on 24/08/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func buttonCricket(_ sender: UIButton) {
        
        NotificationCenter.default.post(name:.Cricket,object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonFootabll(_ sender: UIButton) {
        
        NotificationCenter.default.post(name:.Football,object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonVolleyball(_ sender: UIButton) {
        
        NotificationCenter.default.post(name:.Volleyball,object: nil)
        self.navigationController?.popViewController(animated: true)
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
