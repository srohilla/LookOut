
import MapKit

extension FindFriendViewController: MKMapViewDelegate {
  
  // 1, mapView(_:viewForAnnotation:) is the method that gets called for every annotation you add to the map (kind of like tableView(_:cellForRowAtIndexPath:) when working with table views), to return the view for each annotation.
  func mapView(_ mapView: MKMapView,
    viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     // if let annotation = annotation as? Artwork {
        let identifier = "artPin"
    
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
          as? MKPinAnnotationView { // 2
            dequeuedView.annotation = annotation
            view = dequeuedView
            view.image = UIImage(named:"smiley-smile.png")
        } else {
          // 3
          view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
          view.canShowCallout = true
          view.calloutOffset = CGPoint(x: -5, y: 5)
          view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
          
        
          view.image = UIImage(named:"smiley-smile.png")
            
    }
        
       // view.pinTintColor = annotation.pinTintColor()
        return view
     // }
    //  return nil
  }
    
  //tell MapKit what to do when the callout button is tapped
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
    UserDefaults.standard.set(view.annotation?.title, forKey: "recieverfriend")
    print("I am Tapped")
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewWindow")
    self.present(vc!, animated: true, completion: nil)
    

  }
  
}
