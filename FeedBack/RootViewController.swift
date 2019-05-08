//
//  RootViewController.swift
//  FeedBack
//
//  Created by Julian on 08.05.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import UIKit
import FirebaseAuth

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
