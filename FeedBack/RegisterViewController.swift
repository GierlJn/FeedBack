
import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class RegisterViewController: UIViewController, UITextFieldDelegate, LoginButtonDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBLoginButton()
        loginButton.delegate = self
        loginButton.center = view.center
        self.view.addSubview(loginButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ref = Database.database().reference()
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                return
            }
            self.saveInitialUserInfo( Auth.auth().currentUser!, withUsername: "facebookUser")
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //
    }
    

    @IBAction func registerButtonPressed(_ sender: Any) {
        guard !userNameTextField.text!.isEmpty else{
            self.showMessagePrompt("Name can't be empty")
            return
        }
        guard !passwordTextField.text!.isEmpty else{
            self.showMessagePrompt("Password can't be empty")
            return
        }
        guard !emailTextField.text!.isEmpty else{
            self.showMessagePrompt("Email can't be empty")
            return
        }
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            guard let user = result?.user, error == nil else {
                self.showMessagePrompt(error!.localizedDescription)
                return
            }
            let username = self.userNameTextField.text!
            self.saveInitialUserInfo(user, withUsername: username)
        }
    }
    
    func saveInitialUserInfo(_ user: Firebase.User, withUsername username: String) {
        self.showSpinner {}
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        changeRequest?.commitChanges() { (error) in
            self.dismiss(animated: true, completion: nil)
            if let error = error {
                self.showMessagePrompt(error.localizedDescription)
                return
            }
            
            let initialValues = [userNamePath: username,
                                levelPath:1] as [String: Any]
            
            
            self.ref.child("users").child(user.uid).updateChildValues(initialValues)
            self.performSegue(withIdentifier: "goToMain", sender: nil)
        }
        
    }
}
