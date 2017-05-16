//
//  FindFriendViewController.swift
//  LookOut
//
//  Created by Seema Rohilla on 5/15/17.
//  Copyright © 2017 bhakti shah. All rights reserved.
//



import UIKit
import MapKit
import Firebase

class FindFriendViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!

    
    var ref: FIRDatabaseReference?
    var user:String?
    var latitude:Double?
    var longitude:Double?
    fileprivate var locations = [MKPointAnnotation]()
    var userList = [UserModel]()
    var friendlist = [String]()
    var ref_to_db = [FIRDatabaseReference]()
    
    let manager = CLLocationManager()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
               //locations array contains users all location history
        //so we fetch the latest one
        let location = locations[0]
        //how much u wanna zoom
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1,0.1)
        //users current location
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude )
        //create a region
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        //render this to a map
        
        //    mapView.setRegion(region, animated: true)
        
          self.mapView.showsUserLocation=true
        
        //        for friend in friendlist {
        //
        //            ref?.child("users").child(friend).observeSingleEvent(of: .value, with: { (snapshot) in
        //                print("---------HERE-------------")
        //                print(snapshot)
        ////                for users in snapshot.children.allObjects as! [FIRDataSnapshot] {
        ////                    let userObject = users.value as? [String: AnyObject]
        ////                    print(userObject)
        ////                    let username  = userObject?["username"]
        ////                    let email  = userObject?["email"]
        ////                    let currentlocation = userObject?["currentLocation"]
        ////                    if(username?.isEqual(UserDefaults.standard.string(forKey: "username")!))!{
        ////                        //save friendlist
        ////                        self.friendlist=userObject?["friendlist"]
        ////                            as! [String]           }
        ////
        ////                }
        //
        //            });
        //
        //        }
        print("printing size",self.friendlist.count)
        if(self.friendlist.isEmpty)
        {
            print("No Friends")
        }
        else
        {   print("Here")
            //            for (index, element) in self.friendlist.enumerated() {
            //                print("in here")
            //                print(element)
            //               //print(FIRDatabase.database().reference().child("users").child(element))
            //                //self.ref_to_db.append(FIRDatabase.database().reference().child("users").child(element))
            //            }
            for(i,element) in self.friendlist.enumerated(){
                print("printing index ",i)
                FIRDatabase.database().reference().child("users").child(element).child("currentLocation").observeSingleEvent(of: .value, with: { (snapshot) in
                    if(snapshot.exists())
                    {
                        let value = snapshot.value as? NSDictionary
                        print(value?["latitude"])
                        print(value?["longitude"])
                        //print(snapshot.value(forKey: "latitude"))
                        let annotation = MKPointAnnotation()
                        //print("printting element",element)
                        //print(element.child("currentLocation").child("latitude").v)
                        annotation.title = self.friendlist[i] as? String
                        annotation.coordinate = CLLocationCoordinate2D(latitude: value?["latitude"] as! Double, longitude:value?["longitude"] as! Double)
                        self.mapView.addAnnotation(annotation)
                        print("current Location of the frnz",snapshot)
                    }
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            }
        //    self.mapView.addAnnotation(annotation)
        }
        
        
        
        
        //        let locations = [
        //            ["title": "New York, NY",    "latitude": 40.713054, "longitude": -74.007228],
        //            ["title": "Los Angeles, CA", "latitude": 34.052238, "longitude": -118.243344],
        //            ["title": "Chicago, IL",     "latitude": 41.883229, "longitude": -87.632398]
        //        ]
        
     
        
        
    }
    
    override func loadView() {
        super.loadView()
        //self.ref = FIRDatabase.database().reference()
        let ref = FIRDatabase.database().reference().child("users").child(UserDefaults.standard.string(forKey: "username")!).child("FriendList")
        
        print("printing ref",ref)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                print("printing snapshot",snapshot)
                self.friendlist = (((snapshot.value as AnyObject).allValues)! as? [String])!
                print("printing freind list ",self.friendlist)
                
            }
        })
        
        
        
        
        
        
        //        ref?.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
        //            print("----------------------")
        //
        //            if snapshot.childrenCount > 0 {
        //                for users in snapshot.children.allObjects as! [FIRDataSnapshot] {
        //                    let userObject = users.value as? [String: AnyObject]
        //                    print(userObject)
        //                    let username  = userObject?["username"]
        //                    let email  = userObject?["email"]
        //                    let currentlocation = userObject?["currentLocation"]
        //                    if(username?.isEqual(UserDefaults.standard.string(forKey: "username")!))!{
        //                        //save friendlist
        //                        self.friendlist=userObject?["friendlist"]
        //          as! [String]           }
        //
        //                }
        //            }
        //        });
        //
        
        
        
    }
    //returns the list of friends that the user has
    func getFriends()
    {
        let ref = FIRDatabase.database().reference().child("users").child(UserDefaults.standard.string(forKey: "username")!).child("FriendList")
        
        print("printing ref",ref)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                print("printing snapshot",snapshot)
                self.friendlist = (((snapshot.value as AnyObject).allValues)! as? [String])!
                print("printing freind list ",self.friendlist)
            }
        })
        
        //print("friends printing")
        print("printing size",self.friendlist.count)
        if(self.friendlist.isEmpty)
        {
            print("No Friends")
        }
        else
        {
            for (index, element) in self.friendlist.enumerated() {
                self.ref_to_db.append((self.ref?.child("users").child(element))!)
            }
            for(i,element) in self.ref_to_db.enumerated(){
                element.child("currentLocation").observeSingleEvent(of: .value, with: { (snapshot) in
                    if(snapshot.exists())
                    {
                        print("current Location of the frnz",snapshot)
                    }
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        //        let ref = FIRDatabase.database().reference().child("users").child(UserDefaults.standard.string(forKey: "username")!).child("FriendList")
        //
        //        print("printing ref",ref)
        //
        //        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        //            if snapshot.exists() {
        //                print("printing snapshot",snapshot)
        //                self.friendlist = (((snapshot.value as AnyObject).allValues)! as? [String])!
        //                print("printing freind list ",self.friendlist)
        //            }
        //        })
        
        //     print("friends printing")
        //        print("printing size",self.friendlist.count)
        //        if(self.friendlist.isEmpty)
        //        {
        //            print("No Friends")
        //        }
        //        else
        //        {
        //            for (index, element) in self.friendlist.enumerated() {
        //                self.ref_to_db.append((self.ref?.child("users").child(element))!)
        //            }
        //            for(i,element) in self.ref_to_db.enumerated(){
        //                element.child("currentLocation").observeSingleEvent(of: .value, with: { (snapshot) in
        //                    if(snapshot.exists())
        //                    {
        //                        print("current Location of the frnz",snapshot)
        //                    }
        //
        //                }) { (error) in
        //                    print(error.localizedDescription)
        //                }
        //
        //            }
        //        }
        //
        //
        //
        
    }
    func getAllLocation()
    {
        //        if(self.friendlist.isEmpty)
        //        {
        //        print("No Friends")
        //        }
        //        else
        //        {
        //            for (index, element) in self.friendlist.enumerated() {
        //                self.ref_to_db.append((self.ref?.child("users").child(element))!)
        //            }
        //            for(i,element) in self.ref_to_db.enumerated(){
        //                element.child("currentLocation").observeSingleEvent(of: .value, with: { (snapshot) in
        //                    if(snapshot.exists())
        //                    {
        //                        print("current Location of the frnz",snapshot)
        //                    }
        //                    
        //                }) { (error) in
        //                    print(error.localizedDescription)
        //                }
        //               
        //            }
        //        }
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

