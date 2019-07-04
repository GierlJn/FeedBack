//
//  RootViewController.swift
//  FeedBack
//
//  Created by Julian on 08.05.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn

class RootViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var googeSignInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "goToMain", sender: self)
        } else {
            // No user is signed in.
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
