//
//  SignUpViewController.swift
//  LookOut
//
//  Created by bhakti shah on 5/13/17.
//  Copyright © 2017 bhakti shah. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var PassWord: UITextField!
    var ref: FIRDatabaseReference?
    
    @IBAction func createAccount(_ sender: Any) {
        if (self.Email.text?.isEmpty)!  || (self.PassWord.text?.isEmpty)! || (self.userName.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Error", message: "Please enter the missing Field", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            //To check if the username already exists or not if so show alert else add to db
            self.ref = FIRDatabase.database().reference()
            ref?.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if snapshot.hasChild(self.userName.text!){
                    
                    let alertController = UIAlertController(title: "Error", message: "UserName Already Exists", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                    //enter data to db and email auth to register.
                else{
                    FIRAuth.auth()?.createUser(withEmail: self.Email.text!, password: self.PassWord.text!) { (user, error) in
                        
                        if error == nil {
                            UserDefaults.standard.set(true,forKey:"LoggedIn")
                            UserDefaults.standard.set(self.userName.text,forKey: "username")
                            UserDefaults.standard.set(self.Email.text,forKey: "email")
                            UserDefaults.standard.set(self.PassWord.text, forKey: "password")
                            UserDefaults.standard.synchronize()
                            print("You have successfully signed up")
                            //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                            self.ref?.child("users").child(self.userName.text!).child("email").setValue(self.Email.text)
                        self.ref?.child("users").child(self.userName.text!).child("username").setValue(self.userName.text)
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabController")
                            self.present(vc!, animated: true, completion: nil)
                            
                            
                        } else {
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    
                }
            })
            
           
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


}
