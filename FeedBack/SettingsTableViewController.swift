//
//  SettingsTableViewController.swift
//  FeedBack
//
//  Created by Julian on 08.05.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import UIKit
import Firebase

protocol SettingsDelegate: AnyObject{
    func userNameHasChanged(_ userName: String)
    func emailHasChanged(_ email: String)
}

class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var userProfilePicture: UIButton!
    @IBOutlet weak var passwordButtonOutlet: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    weak var delegate: SettingsDelegate?
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user{
                self.userNameTextField.text = user.displayName!
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    @IBAction func changePasswordButtonTouched(_ sender: Any) {
        
        //performSegue
    }
    
    @IBAction func emailGotEdited(_ sender: Any) {
        //delegate?.emailHasChanged(emailTextField.text!)
        //performEmailSegue
    }
    
    @IBAction func userNameGotEdited(_ sender: Any) {
        delegate?.userNameHasChanged(userNameTextField.text!)
    }
    
    @IBAction func signOutButtonTouched(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"rootNavigationController") as! RootNavigationController
            self.present(rootViewController, animated: true, completion: nil)
        }
        catch{
            print("Error: problem signing out")
        }
    }
    
    @IBAction func setProfilePictureButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Change Avatar", message: "", preferredStyle: .actionSheet)
        
        let profileImagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take a photo", style: .default) { (action) in
                profileImagePicker.allowsEditing = false
                profileImagePicker.sourceType = UIImagePickerController.SourceType.camera
                profileImagePicker.cameraCaptureMode = .photo
                profileImagePicker.modalPresentationStyle = .fullScreen
                self.present(profileImagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photosLibraryAction = UIAlertAction(title: "Pick image", style: .default) { (action) in
                profileImagePicker.sourceType = .photoLibrary
                profileImagePicker.delegate = self
                self.present(profileImagePicker, animated: true, completion: nil)
            }
            alertController.addAction(photosLibraryAction)
        }
        
        alertController.addAction(UIAlertAction(title: "Abort", style: .destructive, handler: { (action) in
            return
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        guard let optimizedImageData = selectedImage.pngData() else { return }
        uploadProfileImage(imageData: optimizedImageData)
        picker.dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
//        //if let profileImage = info[UIImagePickerControllerOriginalImage] as? UIImage, let optimizedImageData = UIImageJPEGRepresentation(profileImage, 0.6){
//            //uploadProfileImage(imageData: optimizedImageData)
//        //}
//        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        picker.dismiss(animated: true, completion:nil)
//    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion:nil)
    }
    
    func uploadProfileImage(imageData: Data){
        let activityIndicator = UIActivityIndicatorView.init(style: .gray)
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        let storageReference = Storage.storage().reference()
        let currentUser = Auth.auth().currentUser
        let profileImageRef = storageReference.child("users").child(currentUser!.uid).child("\(currentUser!.uid)-profileImage.jpg")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
            
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            
            if error != nil{
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            } else {
                self.userProfilePicture.setImage(UIImage(data: imageData), for: .normal) 

                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
                self.tableView.reloadData()
            }
        }
    }
    
}
