//
//  ChangePasswordViewController.swift
//  FeedBack
//
//  Created by Julian on 08.05.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var oldPasswordToggleOutlet: UIButton!
    @IBOutlet weak var newPasswordToggleOutlet: UIButton!
    @IBOutlet weak var confirmPasswordToggleOutlet: UIButton!
    
    var oldPasswordShown = false
    var newPasswordShown = false
    var confirmPasswordShown = false
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: oldPasswordTextField.text!)
        
        // Prompt the user to re-provide their sign-in credentials
        
        user?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                print("error: \(error)")
                //TODO: alert
            } else {
                print("successfully reauthenticated")
                self.changePassword()
            }
        })
    }
    
    private func changePassword(){
        let user = Auth.auth().currentUser
        //TODO check if not nil
        user?.updatePassword(to: newPasswordTextField.text!, completion: { (error) in
            if let error = error {
                print("new password error: \(error)")
            }else{
                print("password changed")
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    @IBAction func toggleConfirmPassword(_ sender: Any) {
        confirmPasswordShown = !confirmPasswordShown
        confirmPasswordTextField.isSecureTextEntry = !confirmPasswordTextField.isSecureTextEntry
        if(confirmPasswordShown){
            let image = UIImage(named: "eye_open")
            confirmPasswordToggleOutlet.setImage(image, for: UIControl.State.normal)
        }else{
            let image = UIImage(named: "eye_closed")
            confirmPasswordToggleOutlet.setImage(image, for: UIControl.State.normal)
        }
    }
    
    @IBAction func toggleOldPassword(_ sender: Any) {
        oldPasswordTextField.isSecureTextEntry = !oldPasswordTextField.isSecureTextEntry
        oldPasswordShown = !oldPasswordShown
        if(oldPasswordShown){
            let image = UIImage(named: "eye_open")
            oldPasswordToggleOutlet.setImage(image, for: UIControl.State.normal)
        }else{
            let image = UIImage(named: "eye_closed")
            oldPasswordToggleOutlet.setImage(image, for: UIControl.State.normal)
        }
    }
    
    @IBAction func toggleNewPassword(_ sender: Any) {
        newPasswordTextField.isSecureTextEntry = !newPasswordTextField.isSecureTextEntry
        newPasswordShown = !newPasswordShown
        if(newPasswordShown){
            let image = UIImage(named: "eye_open")
            newPasswordToggleOutlet.setImage(image, for: UIControl.State.normal)
        }else{
            let image = UIImage(named: "eye_closed")
            newPasswordToggleOutlet.setImage(image, for: UIControl.State.normal)
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
