//
//  GameViewController.swift
//  FeedBack
//
//  Created by Julian on 08.04.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var avatarPicture: UIImageView!
    @IBOutlet weak var tableViewTest: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewTest.delegate = self
        tableViewTest.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CharityData.sampleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ActiveDonationViewCell", owner: self, options: nil)?.first as! ActiveDonationViewCell
        let character = CharityData.sampleData[indexPath.row]
        
        cell.charityNameLabel.text = character["name"] as? String
        cell.charityAvatar.image = character["picture"] as? UIImage
        cell.monthlyProgress.progress = (character["progress"] as? Float)!
        cell.levelLabel.text = character["points"] as? String
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129.5
    }


}
