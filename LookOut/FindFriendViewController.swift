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

class FindFriendViewController: UIViewController,CLLocationManagerDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 2000
    
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
        
    
        
        self.mapView.showsUserLocation=true
        
        
        print("printing size",self.friendlist.count)
        if(self.friendlist.isEmpty)
        {
            print("No Friends")
        }
        else
        {   print("Here")
                       for(i,element) in self.friendlist.enumerated(){
                print("printing index ",i)
                FIRDatabase.database().reference().child("users").child(element).child("currentLocation").observeSingleEvent(of: .value, with: { (snapshot) in
                    if(snapshot.exists())
                    {
                        let value = snapshot.value as? NSDictionary
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
        
        
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         let ref = FIRDatabase.database().reference().child("users").child(UserDefaults.standard.string(forKey: "username")!).child("FriendList")
        self.mapView.delegate=self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        let initialLocation=CLLocation(latitude: UserDefaults.standard.double(forKey: "currentLatitude"), longitude: UserDefaults.standard.double(forKey: "currentLongitude"))
        centerMapOnLocation(initialLocation)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                print("printing snapshot",snapshot)
                self.friendlist = (((snapshot.value as AnyObject).allValues)! as? [String])!
                print("printing freind list ",self.friendlist)
                
            }
        })

        
        
    }
    func getAllLocation()
    {
      
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        func centerMapOnLocation(_ location: CLLocation) {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
