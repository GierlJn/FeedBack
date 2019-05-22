//
//  RegisterViewController.swift
//  FeedBack
//
//  Created by Julian on 28.04.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            self.saveInitialUserInfo(user, withUsername: username)
            /*
            if(self.userNameTextField.text! != ""){
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.userNameTextField.text!
                changeRequest?.commitChanges { (error) in
                    if(error != nil){
                        print(error!)
                    }
                    self.performSegue(withIdentifier: "goToMain", sender: self)
                }
            }
            */
                
        }
    }
    
    func saveInitialUserInfo(_ user: Firebase.User, withUsername username: String) {
        self.showSpinner {}
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        // Commit profile changes to server
        changeRequest?.commitChanges() { (error) in
            self.dismiss(animated: true, completion: nil)
            if let error = error {
                self.showMessagePrompt(error.localizedDescription)
                return
            }
            
            let initialValues = [userNamePath: username,
                                levelPath:1,
                                totaldonationsPath:0] as [String: Any]
            
            self.ref.child("users").child(user.uid).updateChildValues(initialValues)
            self.performSegue(withIdentifier: "goToMain", sender: nil)
        }
        
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
