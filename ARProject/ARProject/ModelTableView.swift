//
//  Sign Out VC.swift
//  ARProject
//
//  Created by Ravi on 25/09/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import AFNetworking

final class ModelTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let userDefault = UserDefaults.standard
    var tableitems: [String] = ["Missile", "Shelby", "Ship"]
    var url: String?
    var modelname: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView?.register(UINib(nibName: String(describing: TableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: "Cell")
        guard let emailId = Auth.auth().currentUser?.email else { return }
        emailLabel.text = "Hello  "
        emailLabel.text?.append(emailId)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.title = "Model List"
    }
    
    @IBAction private func logOutBtnPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
            self.userDefault.removeObject(forKey: "userSignedIn")
            userDefault.synchronize()
            var viewControllers = navigationController?.viewControllers
            viewControllers?.removeLast(1)
            if let vc = viewControllers {
                navigationController?.setViewControllers(vc, animated: true)
            }
            } catch {
            print(error.localizedDescription)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableitems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell {
           cell.labelField.text = tableitems[indexPath.row]
           return cell
        }
        return UITableViewCell()
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        modelname = tableitems[indexPath.row]
        let obj = Model()
        obj.download(filename: tableitems[indexPath.row])
        performSegue(withIdentifier: "ARSessionSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let arsessionVC = segue.destination as? ARSession {
        arsessionVC.modelname = modelname
        }
    }
}
