//
//  SettingsTableViewController.swift
//  FeedBack
//
//  Created by Julian on 08.05.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import UIKit
import Firebase

protocol SettingsDelegate: AnyObject{
    func userNameHasChanged(_ userName: String)
    func emailHasChanged(_ email: String)
}

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var userAvatarOutlet: UIImageView!
    @IBOutlet weak var passwordButtonOutlet: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    weak var delegate: SettingsDelegate?
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user{
                //self.userNameLabel.text = user.displayName!
            }
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    @IBAction func changePasswordButtonTouched(_ sender: Any) {
        
        //performSegue
    }
    
    @IBAction func emailGotEdited(_ sender: Any) {
        delegate?.emailHasChanged(emailTextField.text!)
    }
    
    @IBAction func userNameGotEdited(_ sender: Any) {
        delegate?.userNameHasChanged(userNameTextField.text!)
    }
    
    @IBAction func signOutButtonTouched(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"rootNavigationController") as! RootNavigationController
            self.present(rootViewController, animated: true, completion: nil)
        }
        catch{
            print("Error: problem signing out")
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
