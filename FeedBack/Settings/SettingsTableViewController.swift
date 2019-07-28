
import UIKit
import Firebase
import SDWebImage
import FBSDKLoginKit
import GoogleSignIn

protocol SettingsDelegate: AnyObject{
    func userNameHasChanged(_ userName: String)
    func emailHasChanged(_ email: String)
}

class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GIDSignInDelegate, GIDSignInUIDelegate{

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var passwordButtonOutlet: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var linkFacebookSwitch: UISwitch!
    @IBOutlet weak var newsNotificationSwitch: UISwitch!
    @IBOutlet weak var leaderBoardNotificationSwitch: UISwitch!
    @IBOutlet weak var linkGoogleSwitch: UISwitch!
    
    weak var delegate: SettingsDelegate?
    var ref: DatabaseReference!
    let achievementManager = AchievementManager()
    var user: User?
    var userAchievements = [AchievementFirebase]()
    var alertQueue = [UIAlertController]()
    var currentUser: Firebase.User?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwitches()
        currentUser = Firebase.Auth.auth().currentUser
        self.emailTextField.text = currentUser?.email
        ref = Database.database().reference(withPath: usersPath).child(currentUser!.uid)
        ref.observe(DataEventType.value) { (snapshot) in
            guard let user = User(snapshot: snapshot) else { return }
            self.user = user
            self.userNameTextField.text = user.userName
            self.userAchievements = user.achievementHolder.achievements
            self.setupUserImage()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        //
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        //
    }
    
    fileprivate func setupSwitches(){
        updateFacebookSwitch()
        updateGoogleSwitch()
        updateNotificationSwitch()
    }
    
    fileprivate func updateGoogleSwitch(){
        if(hasLinkedProvider(providerId: "google.com")){
            linkGoogleSwitch.isOn = true
            return
        }
        linkGoogleSwitch.isOn = false
    }
    
    fileprivate func updateFacebookSwitch() {
        if(hasLinkedProvider(providerId: "facebook.com")){
            linkFacebookSwitch.isOn = true
        }else{
            linkFacebookSwitch.isOn = false
        }
    }
    
    func updateNotificationSwitch(){
        leaderBoardNotificationSwitch.isOn = UserDefaults.standard.bool(forKey: "pushNotificationKey")

    }
    
    fileprivate func hasLinkedProvider(providerId: String)->Bool{
        let providerData = Auth.auth().currentUser?.providerData
        return providerData?.contains(where: { (provider) -> Bool in
            provider.providerID == providerId
        }) ?? false
    }
    
    fileprivate func setupUserImage() {
        let storageReference = Storage.storage().reference()
        let profileImageRef = storageReference.child(usersPath).child(user!.uniqueId).child("\(user!.uniqueId)-profileImage.jpg")
        let placeholderImage = UIImage(named: "user.png")
        
        userImage.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
        
        print("set user image to ")
        print(profileImageRef)
        userImage.setRounded()
        tableView.reloadData()
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
    
    @IBAction func leaderboardNotificationSwitchPressed(_ sender: Any) {
        if(!userHasAchievement(achievementId: "pushnotificationactivated")){
            print("")
            grantAchievementWithAlert("pushnotificationactivated")
        }
        let isActive = UserDefaults.standard.bool(forKey: "pushNotificationKey")
        UserDefaults.standard.set(!isActive, forKey: "pushNotificationKey")
        updateNotificationSwitch()
    }
    
    @IBAction func newsSwitchPressed(_ sender: Any) {
    }
    
    
    @IBAction func contactSupportButtonPressed(_ sender: Any) {
        print("setupuserImage contactsup")
        setupUserImage()
    }
    
    @IBAction func privacyButtonPressed(_ sender: Any) {
    }
    
    @IBAction func emailGotEdited(_ sender: Any) {
        delegate?.emailHasChanged(emailTextField.text!)
        //performEmailSegue
    }
    
    @IBAction func userNameGotEdited(_ sender: Any) {
        delegate?.userNameHasChanged(userNameTextField.text!)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            LoginManager().logOut()
            UserDefaults.standard.set(false, forKey: "pushNotificationKey")
            let rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"rootNavigationController") as! RootNavigationController
            self.present(rootViewController, animated: true, completion: nil)
        }
        catch{
            print("Error: problem signing out")
        }
    }
    
    @IBAction func signOutButtonTouched(_ sender: Any) {
        signOut()
    }
    
    func setProfilePicture() {
        let alertController = UIAlertController(title: "Change Avatar", message: "", preferredStyle: .actionSheet)
        
        let profileImagePicker = UIImagePickerController()
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take a photo", style: .default) { (action) in
                profileImagePicker.allowsEditing = false
                profileImagePicker.delegate = self
                profileImagePicker.sourceType = UIImagePickerController.SourceType.camera
                profileImagePicker.cameraCaptureMode = .photo
                profileImagePicker.modalPresentationStyle = .fullScreen
                print("setupcamera")
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
    
    @IBAction func setProfilePictureButtonTapped(_ sender: Any) {
        setProfilePicture()
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("pic error taken")
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        print("pic taken")
        guard let optimizedImageData = selectedImage.jpegData(compressionQuality: 0.5) else { return }
        
        //SDImageCache.shared.clearMemory()
        //SDImageCache.shared.clearDisk()
        self.uploadProfileImage(imageData: optimizedImageData)

        
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
                //self.setupUserImage()
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
                
                let imageLinkRef = Database.database().reference(withPath: "users").child(currentUser!.uid)
                let timestamp = NSDate().timeIntervalSince1970
                imageLinkRef.updateChildValues(  ["profileImageSet" : timestamp ])
                
                self.setupUserImage()
                self.tableView.reloadData()
            }
        }
    }


    
    @IBAction func linkGoogleSwitchValueChanged(_ sender: Any) {
        GIDSignIn.sharedInstance()?.delegate = self
        if(!hasLinkedProvider(providerId: "google.com")){
            GIDSignIn.sharedInstance().signIn()
        }else{
            updateGoogleSwitch()
            Auth.auth().currentUser?.unlink(fromProvider: "google.com", completion: { (user, error) in
                if(error != nil){
                    print(error.debugDescription)
                    self.showMessagePromptWithTitle(error!.localizedDescription, title: "Error")
                    self.updateGoogleSwitch()
                    return
                }
                self.showMessagePrompt("Your Google account is now unlinked from this account")
                GIDSignIn.sharedInstance()?.signOut()
                AccessToken.current = nil
                self.updateGoogleSwitch()
            })
        }
        updateGoogleSwitch()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil) {
            print(error.debugDescription)
            self.showMessagePromptWithTitle(error!.localizedDescription, title: "Error")
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().currentUser?.link(with: credential, completion: { (result, error) in
            if(error != nil){
                self.showMessagePromptWithTitle(error!.localizedDescription, title: "Error")
                self.updateGoogleSwitch()
                return
            }else{
                self.updateGoogleSwitch()
            }
        })
    }
    
    @IBAction func linkFacebookSwitchValueChanged(_ sender: Any) {
        if(!hasLinkedProvider(providerId: "facebook.com")){
            LoginManager().logIn(permissions: [], from: self) { (result, error) in
                if(error != nil){
                    print(error.debugDescription)
                    self.showMessagePromptWithTitle(error!.localizedDescription, title: "Error")
                    self.updateFacebookSwitch()
                    return
                }
                if(AccessToken.current == nil){
                    print("Accesstoken is still nil after loggIn")
                    self.updateFacebookSwitch()
                    return
                }
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().currentUser?.link(with: credential, completion: { (authResult, error) in
                    if(error != nil){
                        print(error.debugDescription)
                        self.showMessagePromptWithTitle(error!.localizedDescription, title: "Error")
                        self.updateFacebookSwitch()
                        return
                    }else{
                        //linkin succesful
                    }
                    self.updateFacebookSwitch()
                })
            }
        }else{
            updateFacebookSwitch()
            Auth.auth().currentUser?.unlink(fromProvider: "facebook.com", completion: { (user, error) in
                if(error != nil){
                    print(error.debugDescription)
                    self.showMessagePromptWithTitle(error!.localizedDescription, title: "Error")
                    self.updateFacebookSwitch()
                    return
                }
                self.showMessagePrompt("Your Facebook account is now unlinked from this account")
                LoginManager().logOut()
                //AccessToken.current = nil
                self.updateFacebookSwitch()
            })
        }
    }
    func grantAchievementWithAlert(_ achievementKey: String){
        guard let achievement = achievementManager.getAchievementWithKey(achievementKey) else { return }
        achievementManager.grantAchievementForKey(achievementKey, userId: currentUser!.uid)
        
        print("grantachievement")
        let alert = UIAlertController(title: achievement.name, message: achievement.messageWhenAchieved, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Nice!", style: .default) { (action) in
            return
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func userHasAchievement(achievementId: String)->Bool{
        if(userAchievements.contains(where: { (entry) -> Bool in
            entry.id == achievementId
        })){
            return true
        }else{
            return false
        }
    }
}
