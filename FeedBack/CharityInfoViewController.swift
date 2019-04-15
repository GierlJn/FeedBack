//
//  CharityInfoViewController.swift
//  FeedBack
//
//  Created by Julian on 15.04.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import UIKit

class CharityInfoViewController: UIViewController {

    @IBOutlet weak var charityLogo: UIImageView!
    
    @IBOutlet weak var charityTitle: UILabel!
    
    @IBOutlet weak var charityInfoBox: UILabel!
    
    var charityName = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        charityInfoBox.numberOfLines = 0
        charityInfoBox.sizeToFit()
        
        // Do any additional setup after loading the view.
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
