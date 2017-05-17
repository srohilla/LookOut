//
//  AboutMeViewController.swift
//  LookOut
//
//  Created by Seema Rohilla on 5/16/17.
//  Copyright © 2017 bhakti shah. All rights reserved.
//

import UIKit
import Firebase

class AboutMeViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    let picker = UIImagePickerController()
    @IBOutlet weak var myImageView: UIImageView!
    
   
    @IBAction func photoFromLibrary(_ sender: UIBarButtonItem) {
    picker.allowsEditing = false
    picker.sourceType = .photoLibrary
    picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    picker.modalPresentationStyle = .popover
    present(picker, animated: true, completion: nil)
    picker.popoverPresentationController?.barButtonItem = sender
    }
    
    @IBAction func shootPhoto(_ sender: UIBarButtonItem) {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
    picker.allowsEditing = false
    picker.sourceType = UIImagePickerControllerSourceType.camera
    picker.cameraCaptureMode = .photo
    picker.modalPresentationStyle = .fullScreen
    present(picker,animated: true,completion: nil)
    } else {
    noCamera()
    }
    }
    func noCamera(){
    let alertVC = UIAlertController(
    title: "No Camera",
    message: "Sorry, this device has no camera",
    preferredStyle: .alert)
    let okAction = UIAlertAction(
    title: "OK",
    style:.default,
    handler: nil)
    alertVC.addAction(okAction)
    present(
    alertVC,
    animated: true,
    completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        myImageView.contentMode = .scaleAspectFit //3
        myImageView.image = chosenImage //4
        
    
        
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
   
  

    @IBOutlet weak var username: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text=UserDefaults.standard.string(forKey: "username")
        picker.delegate = self
   
        //Looks for single or multiple taps.
       
    }
    

    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
           // dismiss(animated: true, completion: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrimaryView")
            self.present(vc!, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}
