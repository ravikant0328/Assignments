//
//  Sign Up VC.swift
//  ARProject
//
//  Created by Ravi on 24/09/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn
import CoreLocation
import CoreBluetooth

final class Registration: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailIdTextField: UITextField!
    
    let userDefault = UserDefaults.standard
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if userDefault.bool(forKey: "userSignedIn") {
            performSegue(withIdentifier: "SignIn", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        //initLocalBeacon()
        //GIDSignIn.sharedInstance().signIn()
    }
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if error == nil {
                print("User Created & Signed In")
                let alert = UIAlertController(title: "Congrats!!!", message: "User Registered", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Oops!!!", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                print(error as Any)
                print(error?.localizedDescription as Any)
            }
        }
    }

    @IBAction private func signUpBtnPressed(_ sender: Any) {
        guard let emailid = emailIdTextField.text, let password = passwordTextField.text else { return }
            createUser(email: emailid, password: password)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func signinuser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if  error == nil {
                print("User Signed in")
                self.userDefault.set(true, forKey: "userSignedIn")
                self.userDefault.synchronize()
                self.performSegue(withIdentifier: "SignIn", sender: self)
            } else {
                let alert = UIAlertController(title: "OOPS!!!", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                print(error as Any)
                print(error?.localizedDescription as Any)
                self.passwordTextField.text = ""
            }
        }
    }
    
    @IBAction private func logInBtnPressed(_ sender: Any) {
        guard let emailid = emailIdTextField.text, let password = passwordTextField.text else { return }
        signinuser(email: emailid, password: password)
    }
    
//    var localBeacon: CLBeaconRegion!
//    var beaconPeripheralData: NSDictionary!
//    var peripheralManager: CBPeripheralManager!
//
//    func initLocalBeacon() {
//        if localBeacon != nil {
//            stopLocalBeacon()
//        }
//        let proximityUUID = UUID(uuidString: "7EC954D0-FE20-4041-B2A0-BD537C22F18A")
//        let major: CLBeaconMajorValue = 100
//        let minor: CLBeaconMinorValue = 1
//        let beaconID = "com.ymedialabs.in.ARProject"
//        localBeacon = CLBeaconRegion(proximityUUID: proximityUUID!, major: major, minor: minor, identifier: beaconID)
//        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
//        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
//    }
//
//    func stopLocalBeacon() {
//        peripheralManager.stopAdvertising()
//        peripheralManager = nil
//        beaconPeripheralData = nil
//        localBeacon = nil
//    }
//
//    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//        if peripheral.state == .poweredOn {
//            if let requiredata = beaconPeripheralData as? [String: AnyObject] {
//            peripheralManager.startAdvertising(requiredata)
//            }
//        } else if peripheralManager.state == .poweredOff {
//            peripheralManager.stopAdvertising()
//        }
//    }
    
}
