//
//  FavViewController.swift
//  LookOut
//
//  Created by bhakti shah on 5/14/17.
//  Copyright © 2017 bhakti shah. All rights reserved.
//

import UIKit
import Firebase


class FavViewController: UIViewController,UISearchBarDelegate {
    @IBOutlet weak var SearchResult: UILabel!

    @IBOutlet weak var searchFriend: UISearchBar!
    
    @IBOutlet weak var addFreindToList: UIButton!
    
    @IBAction func addFriendToList(_ sender: Any) {
       var locationRef=self.ref?.child("users").child(UserDefaults.standard.string(forKey: "username")!).child("FriendList").childByAutoId()
        locationRef?.setValue(self.SearchResult.text)
//        self.ref?.child("users/"+UserDefaults.standard.string(forKey:"username")!+"/FriendList").setValue(self.SearchResult.text)
        
        
        let alertController = UIAlertController(title: "Sucess!", message: "Your Frined \(String(describing: self.SearchResult.text))has been added sucessfully", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        searchFriend.text=""
        addFreindToList.isHidden=true
        SearchResult.isHidden=true
        
        

        
    
    }
  
    var ref: FIRDatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFriend.delegate=self
        SearchResult.isHidden=true
        addFreindToList.isHidden=true
        searchFriend.enablesReturnKeyAutomatically=true
        
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
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        
    }
    // when the search edit ends, it checks if the user exists
       public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.ref = FIRDatabase.database().reference()
        ref?.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if snapshot.hasChild(self.searchFriend.text!)
            {
                self.SearchResult.isHidden=false
                self.SearchResult.text = self.searchFriend.text
                self.addFreindToList.isHidden=false
                
                
            }
            else
            {
                let alertController = UIAlertController(title: "Error", message: "No such user exists, please try again", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
               self.present(alertController, animated: true, completion: nil)
            }
            

        
    })
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    

}
