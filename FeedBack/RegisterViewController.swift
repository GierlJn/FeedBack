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

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerButtonPressed(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            if(error != nil){
                print(error!)
                return
            }
            print("success")
            
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
