
import UIKit
import Firebase
import FirebaseUI


protocol SettingsDelegate: AnyObject{
    func userNameHasChanged(_ userName: String)
    func emailHasChanged(_ email: String)
}

class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var passwordButtonOutlet: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    weak var delegate: SettingsDelegate?
    var ref: DatabaseReference!
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = Firebase.Auth.auth().currentUser else { return }
        ref = Database.database().reference(withPath: usersPath).child(currentUser.uid)
        ref.observe(DataEventType.value) { (snapshot) in
            guard let user = User(snapshot: snapshot) else { return }
            self.user = user
            self.userNameTextField.text = user.userName
            self.emailTextField.text = currentUser.email
            self.setupUserImage()
        }
    }
    
    fileprivate func setupUserImage() {
        let storageReference = Storage.storage().reference()
        let profileImageRef = storageReference.child(usersPath).child(user!.uniqueId).child("\(user!.uniqueId)-profileImage.jpg")
        let placeholderImage = UIImage(named: "user.png")
        userImage.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
        userImage.setRounded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
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
        guard let optimizedImageData = selectedImage.jpegData(compressionQuality: 0.5) else { return }
        uploadProfileImage(imageData: optimizedImageData)
        picker.dismiss(animated: true, completion: nil)
    }
    
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
        SDImageCache.shared().removeImage(forKey: profileImageRef.fullPath)
        profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            if error != nil{
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            } else {
                self.setupUserImage()
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
                self.tableView.reloadData()
            }
        }
    }
    
}
