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
        
    //    mapView.setRegion(region, animated: true)
        
      //  self.mapView.showsUserLocation=true
        
        
        if UIApplication.shared.applicationState == .active {
              if((UserDefaults.standard.string(forKey: "username")) != nil)
              {
                mapView.showAnnotations(self.locations, animated: true)
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
        
        
        let locations = [
            ["title": "New York, NY",    "latitude": 40.713054, "longitude": -74.007228],
            ["title": "Los Angeles, CA", "latitude": 34.052238, "longitude": -118.243344],
            ["title": "Chicago, IL",     "latitude": 41.883229, "longitude": -87.632398]
        ]
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location["title"] as? String
            annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
            self.mapView.addAnnotation(annotation)
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
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
