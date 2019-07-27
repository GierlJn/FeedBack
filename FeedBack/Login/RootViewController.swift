

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import PDFKit

class RootViewController: UIViewController, GIDSignInUIDelegate, LoginButtonDelegate {
    
    @IBOutlet weak var facebookLoginButton: FBLoginButton!
    @IBOutlet weak var googeSignInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.setGoogleDelegate()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        facebookLoginButton.delegate = self
        facebookLoginButton.permissions = ["public_profile", "email"]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "goToMain", sender: self)
        } else {
            // No user is signed in.
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        if(AccessToken.current == nil){ return }
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                print("error: Facebook sign in")
                return
            }
            let r = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: .get)
            
            r.start(completionHandler: { (test, result, error) in
                if(error == nil)
                {
                    guard let currentUser = Auth.auth().currentUser else{ return }
                    
                    let userManager = UserManager()
                    userManager.isUserRegistered(with: currentUser.uid, completion: { (userExists, user) in
                        if(!userExists){
                            print("user does not exist")
                            let fbData = result as! NSDictionary
                            userManager.createInitialUserInfo(withUsername: fbData.value(forKey: "name") as! String)
                        }else{
                            print("user exists")
                        }
                        
                        let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                        let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "mainTabBarController") as! MainTabBarViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = protectedPage
                    })
                }
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("did log out")
        LoginManager().logOut()
    }

}
