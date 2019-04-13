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
    
    var sampleData:[Dictionary<String, Any>] = [
        [
            "picture": #imageLiteral(resourceName: "wolf"),
            "name" : "NightSaver",
            "progress" : Float(0.33),
            "points" : "12",
        ],
        [
            "picture": #imageLiteral(resourceName: "lion"),
            "name" : "Lannister Foundation",
            "progress" : Float(0.7),
            "points" :  "44",
        ],
        [
            "picture": #imageLiteral(resourceName: "dragon"),
            "name" : "Feeding Dragons",
            "progress" : Float(0.2),
            "points" :  "88",
        ]
    ]
    
    @IBOutlet weak var tableViewTest: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let cellNib = UINib(nibName: "ActiveDonationViewCell", bundle: nil)
        //self.tableViewTest.register(cellNib, forCellReuseIdentifier: "charityCell")
        
        tableViewTest.delegate = self
        tableViewTest.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableViewTest.dequeueReusableCell(withIdentifier: "charityCell", for: indexPath) as! ActiveDonationViewCell
        let cell = Bundle.main.loadNibNamed("ActiveDonationViewCell", owner: self, options: nil)?.first as! ActiveDonationViewCell
        //let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "testCell")!
        // Set text from the data model
        let character = sampleData[indexPath.row]
        
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
