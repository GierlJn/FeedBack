
import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInButtonTouched(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (userData, error) in
            if(error != nil){
                print("Error login in: \(error!)")
            }else{
                self.performSegue(withIdentifier: "goToMain", sender: self)
            }
        }
    }

}
