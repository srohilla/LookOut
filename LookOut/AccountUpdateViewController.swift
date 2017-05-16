//
//  AccountUpdateViewController.swift
//  LookOut
//
//  Created by Seema Rohilla on 5/15/17.
//  Copyright © 2017 bhakti shah. All rights reserved.
//



import UIKit
import Firebase

class AccountUpdateViewController: UIViewController,UITextFieldDelegate {
    

    var ref: FIRDatabaseReference?
    
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func updateInfo(_ sender: Any) {
        
        self.ref = FIRDatabase.database().reference()
        
        
    }

    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text=UserDefaults.standard.string(forKey: "username")
     
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}

