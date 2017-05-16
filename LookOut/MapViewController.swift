//
//  MapViewController.swift
//  LookOut
//
//  Created by bhakti shah on 4/27/17.
//  Copyright © 2017 bhakti shah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAuth

class MapViewController: UIViewController , CLLocationManagerDelegate{
    
    
    //Map
    
    @IBOutlet weak var Map: MKMapView!
    
    
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
        
        Map.setRegion(region, animated: true)
        
        self.Map.showsUserLocation=true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogOutAction(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrimaryView")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    
}

