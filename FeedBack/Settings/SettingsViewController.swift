
import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseDatabase

class SettingsViewController: UIViewController, SettingsDelegate {
    
    private var settingsTableViewController: SettingsTableViewController?
    var newUserName: String?
    var newEmail: String?
    var userNameHasChanged = false
    var emailHasChanged = false
    let user = Auth.auth().currentUser
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        guard let tableViewController = children.first as? SettingsTableViewController else{ return }
        settingsTableViewController = tableViewController
        settingsTableViewController!.delegate = self
    }

    func userNameHasChanged(_ userName: String) {
        newUserName = userName
        userNameHasChanged = true
    }
    
    func emailHasChanged(_ email: String) {
        newEmail = email
        emailHasChanged = true
    }
    
    
    @IBAction func closeButtonTouched(_ sender: Any) {
        saveChanges()
        self.dismiss(animated: false, completion: nil)
    }
    
    private func saveChanges(){
        if(userNameHasChanged){
            saveNewUserName()
            changeUserNameInDatabase()
        }
        if(emailHasChanged){
            saveNewEmail()
        }
    }
    
    private func saveNewUserName(){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = newUserName
        changeRequest?.commitChanges { (error) in
            if(error != nil){
                print("error saving name: \(String(describing: error))")
                //  TODO: show alert
            }else{
                print("new name called")
            }
        }
    }
    
    private func changeUserNameInDatabase(){ self.ref.child(usersPath).child(user!.uid).child(userNamePath).setValue(newUserName)
    }
    
    private func saveNewEmail(){
        print("try to save eamil")
        Auth.auth().currentUser?.updateEmail(to: newEmail!, completion: { (error) in
            if(error != nil){
                print("error saving email: \(String(describing: error))")
                //  TODO: show alert
            }
        })
    }
    
    

}
