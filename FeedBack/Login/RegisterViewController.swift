
import UIKit
import Firebase
import FirebaseAuth


class RegisterViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    var ref: DatabaseReference!
    let userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ref = Database.database().reference()
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
            self.userManager.createInitialUserInfo(withUsername: username)
            self.performSegue(withIdentifier: "goToMain", sender: nil)
        }
    }
    
}
