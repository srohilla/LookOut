//
//  SecondViewController.swift
//  LookOut
//
//  Created by bhakti shah on 5/12/17.
//  Copyright © 2017 bhakti shah. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class SecondViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var TabBar: UITabBar!
    @IBOutlet weak var mapView: MKMapView!
    var ref: FIRDatabaseReference?
    var user:String?
    var latitude:Double?
    var longitude:Double?
    fileprivate var locations = [MKPointAnnotation]()


    
    let manager = CLLocationManager()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.ref = FIRDatabase.database().reference()
        
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
        latitude=location.coordinate.latitude
        longitude=location.coordinate.longitude
        UserDefaults.standard.set(latitude, forKey: "currentLatitude")
        UserDefaults.standard.set(longitude, forKey: "currentLongitude")
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation=true
        
        
        if UIApplication.shared.applicationState == .active {
              if((UserDefaults.standard.string(forKey: "username")) != nil)
              {
           //     mapView.showAnnotations(self.locations, animated: true)
                self.ref?.child("users").child(UserDefaults.standard.string(forKey: "username")!).child("currentLocation").child("latitude").setValue(location.coordinate.latitude)
                self.ref?.child("users").child(UserDefaults.standard.string(forKey: "username")!).child("currentLocation").child("longitude").setValue(location.coordinate.longitude)
           //     print("App is in foreground. New location is %@", location)
            }
            
        } else {
            if((UserDefaults.standard.string(forKey: "username")) != nil){
           
                self.ref?.child("users").child(UserDefaults.standard.string(forKey: "username")!).child("currentLocation").child("latitude").setValue(location.coordinate.latitude)
                self.ref?.child("users").child(UserDefaults.standard.string(forKey: "username")!).child("currentLocation").child("longitude").setValue(location.coordinate.longitude)
            //    print("App is backgrounded. New location is %@", location)
                
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
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
}
