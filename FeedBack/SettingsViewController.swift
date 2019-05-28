
import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
//protocol ProfileViewDelegate: AnyObject{
    //func updateDisplayName(_ newUserName: String)
//}

class SettingsViewController: UIViewController, SettingsDelegate {
    
    private var settingsTableViewController: SettingsTableViewController?
    var newUserName: String?
    var newEmail: String?
    var userNameHasChanged = false
    var emailHasChanged = false
    //weak var delegate: ProfileViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        guard let tableViewController = children.first as? SettingsTableViewController else{
            fatalError("Check storyboard for missing SettingsTableViewController")
        }
        
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
                //self.delegate?.updateDisplayName(self.newUserName!)
            }
        }
    }
    
    private func saveNewEmail(){
        Auth.auth().currentUser?.updateEmail(to: newEmail!, completion: { (error) in
            if(error != nil){
                print("error saving email: \(String(describing: error))")
                //  TODO: show alert
            }
        })
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
