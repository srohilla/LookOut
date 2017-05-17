//
//  ChatViewController.swift
//  LookOut
//
//  Created by Seema Rohilla on 5/16/17.
//  Copyright © 2017 bhakti shah. All rights reserved.
//
import Photos
import UIKit

import Firebase

@objc(ChatViewController)
class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
    UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // Instance variables
    
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
 
    var ref: FIRDatabaseReference!
    var messages: [FIRDataSnapshot]! = []
    var msglength: NSNumber = 30
  
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    var storageRef: FIRStorageReference!
    
   
    
    @IBOutlet weak var clientTable: UITableView!

    
    
    @IBAction func didTapAddPhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            picker.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        present(picker, animated: true, completion:nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text=UserDefaults.standard.string(forKey: "recieverfriend")
        self.clientTable.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        
        configureDatabase()
        configureStorage()
        configureRemoteConfig()
        fetchConfig()
        loadAd()
        logViewLoaded()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

    }
    
    
    func configureStorage() {
        storageRef = FIRStorage.storage().reference()
    }
    func configureRemoteConfig() {
    }
    
    func fetchConfig() {
    }
    
    @IBAction func didPressFreshConfig(_ sender: AnyObject) {
        fetchConfig()
    }
    
    @IBAction func didSendMessage(_ sender: Any) {
        _ = textFieldShouldReturn(textField)

    }
  
    
    @IBAction func didPressCrash(_ sender: AnyObject) {
        fatalError()
    }
    
    @IBAction func inviteTapped(_ sender: AnyObject) {
    }
    
    func logViewLoaded() {
    }
    
    func loadAd() {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= self.msglength.intValue // Bool
    }
    
    // UITableViewDataSource protocol methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
    // UITextViewDelegate protocol methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        textField.text = ""
        view.endEditing(true)
        let data = [Constants.MessageFields.text: text]
        sendMessage(withData: data)
        return true
    }
    
    func sendMessage(withData data: [String: String]) {
        var mdata = data
    
        mdata[Constants.MessageFields.name] = UserDefaults.standard.string(forKey: "username")
        //change photo
        if let photoURL = FIRAuth.auth()?.currentUser?.photoURL {
            mdata[Constants.MessageFields.photoURL] = photoURL.absoluteString
        }
        
        mdata["reciever"] = UserDefaults.standard.string(forKey: "recieverfriend")
        print("sending")
        // Push data to Firebase Database
        self.ref.child("messages").childByAutoId().setValue(mdata)
    }
    

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion:nil)
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        // if it's a photo from the library, not an image from the camera
        if #available(iOS 8.0, *), let referenceURL = info[UIImagePickerControllerReferenceURL] as? URL {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [referenceURL], options: nil)
            let asset = assets.firstObject
            asset?.requestContentEditingInput(with: nil, completionHandler: { [weak self] (contentEditingInput, info) in
                let imageFile = contentEditingInput?.fullSizeImageURL
                let filePath = "\(uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\((referenceURL as AnyObject).lastPathComponent!)"
                guard let strongSelf = self else { return }
                strongSelf.storageRef.child(filePath)
                    .putFile(imageFile!, metadata: nil) { (metadata, error) in
                        if let error = error {
                            let nsError = error as NSError
                            print("Error uploading: \(nsError.localizedDescription)")
                            return
                        }
                        strongSelf.sendMessage(withData: [Constants.MessageFields.imageURL: strongSelf.storageRef.child((metadata?.path)!).description])
                }
            })
        } else {
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            let imagePath = "\(uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            self.storageRef.child(imagePath)
                .put(imageData!, metadata: metadata) { [weak self] (metadata, error) in
                    if let error = error {
                        print("Error uploading: \(error)")
                        return
                    }
                    guard let strongSelf = self else { return }
                    strongSelf.sendMessage(withData: [Constants.MessageFields.imageURL: strongSelf.storageRef.child((metadata?.path)!).description])
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
   
    
    func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("messages").removeObserver(withHandle: _refHandle)
        }
    }
    
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            
            
            let messageSnapshot: FIRDataSnapshot! = snapshot
            
            let message = messageSnapshot.value as! [String:String]
            if((message["reciever"]==UserDefaults.standard.string(forKey: "username") && message["name"]==UserDefaults.standard.string(forKey: "recieverfriend")) || message["name"]==UserDefaults.standard.string(forKey: "username") && message["reciever"]==UserDefaults.standard.string(forKey: "recieverfriend")){
                
                strongSelf.messages.append(snapshot)
                strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
            }
           
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Dequeue cell
        let cell = self.clientTable .dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        // Unpack message from Firebase DataSnapshot
        let messageSnapshot: FIRDataSnapshot! = self.messages[indexPath.row]
        guard let message = messageSnapshot.value as? [String:String] else { return cell }
        print("Message",message)
        if(message["reciever"]==UserDefaults.standard.string(forKey: "username") && message["name"]==UserDefaults.standard.string(forKey: "recieverfriend")){
           
            
        let name = message[Constants.MessageFields.name] ?? ""
        if let imageURL = message[Constants.MessageFields.imageURL] {
            if imageURL.hasPrefix("gs://") {
                FIRStorage.storage().reference(forURL: imageURL).data(withMaxSize: INT64_MAX) {(data, error) in
                    if let error = error {
                        print("Error downloading: \(error)")
                        return
                    }
                    cell.imageView?.image = UIImage.init(data: data!)
                    print("trying to reload data")
                    tableView.reloadData()
                }
            } else if let URL = URL(string: imageURL), let data = try? Data(contentsOf: URL) {
                cell.imageView?.image = UIImage.init(data: data)
            }
            cell.textLabel?.text = "sent by: \(name)"
        } else {
            let text = message[Constants.MessageFields.text] ?? ""
            cell.textLabel?.text = name + ": " + text
            cell.imageView?.image = UIImage(named: "ic_account_circle")
            if let photoURL = message[Constants.MessageFields.photoURL], let URL = URL(string: photoURL),
                let data = try? Data(contentsOf: URL) {
                cell.imageView?.image = UIImage(data: data)
            }
            }}
        else if(message["name"]==UserDefaults.standard.string(forKey: "username") && message["reciever"]==UserDefaults.standard.string(forKey: "recieverfriend")) {
          
            let name = message[Constants.MessageFields.name] ?? ""
            if let imageURL = message[Constants.MessageFields.imageURL] {
                if imageURL.hasPrefix("gs://") {
                    FIRStorage.storage().reference(forURL: imageURL).data(withMaxSize: INT64_MAX) {(data, error) in
                        if let error = error {
                            print("Error downloading: \(error)")
                            return
                        }
                        cell.imageView?.image = UIImage.init(data: data!)
                        print("trying to reload data")
                        tableView.reloadData()
                    }
                } else if let URL = URL(string: imageURL), let data = try? Data(contentsOf: URL) {
                    cell.imageView?.image = UIImage.init(data: data)
                }
                cell.textLabel?.text = "sent by: \(name)"
            } else {
                let text = message[Constants.MessageFields.text] ?? ""
                cell.textLabel?.text = name + ": " + text
                cell.imageView?.image = UIImage(named: "ic_account_circle")
                if let photoURL = message[Constants.MessageFields.photoURL], let URL = URL(string: photoURL),
                    let data = try? Data(contentsOf: URL) {
                    cell.imageView?.image = UIImage(data: data)
                }
            }
        
        
        
        }
        
        return cell
    }
    
  

    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    
}
