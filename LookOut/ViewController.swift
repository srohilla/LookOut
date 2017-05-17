//
//  ViewController.swift
//  LookOut
//
//  Created by bhakti shah on 5/2/17.
//  Copyright © 2017 bhakti shah. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    //list to store all the artist
  //  var userList = [UserModel]()
    var currentUser: String = ""
   
    var ref: FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if((UserDefaults.standard.string(forKey: "LoggedIn")) != nil)
        {
           emailTextField.text = UserDefaults.standard.string(forKey: "email")
            passwordTextField.text=UserDefaults.standard.string(forKey: "password")
        }
        
        
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        
        
        view.addGestureRecognizer(tap)
    }
  
    
    @IBAction func loginAction(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
           
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            self.ref = FIRDatabase.database().reference()
            ref?.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
          //  })
            FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
            
                        if snapshot.childrenCount > 0 {
                         
                          
                                for users in snapshot.children.allObjects as! [FIRDataSnapshot] {
                                let userObject = users.value as? [String: AnyObject]
                                print(userObject)
                                let username  = userObject?["username"]
                                print(username)
                                let email  = userObject?["email"]
                          //      let friendlist = userObject?["friendlist"]
                                if(email?.isEqual(self.emailTextField.text))!{
                                    
                                self.currentUser=username as! String
                                }
                                
                               
                            }
                            
                            //reloading the tableview
                          //  self.tableViewArtists.reloadData()
                        }
               //     })
                    
                  
                    
                
                    print("******************************************")
                    print(self.currentUser)
                    UserDefaults.standard.set(true,forKey:"LoggedIn")
                    UserDefaults.standard.set(self.emailTextField.text,forKey: "email")
                    UserDefaults.standard.set(self.passwordTextField.text, forKey: "password")
                    UserDefaults.standard.set(self.currentUser, forKey: "username")
               //     UserDefaults.standard.set(self.userList,forKey: "userList")
                    UserDefaults.standard.synchronize()
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabController")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
                 })
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

