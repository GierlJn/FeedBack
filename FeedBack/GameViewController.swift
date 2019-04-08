//
//  GameViewController.swift
//  FeedBack
//
//  Created by Julian on 08.04.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sampleData:[Dictionary<String, Any>] = [
        [
            "picture": #imageLiteral(resourceName: "wolf"),
            "name" : "Jon Snow",
        ],
        [
            "picture": #imageLiteral(resourceName: "wolf"),
            "name" : "Daenerys Targaryen",
        ]
    ]
    
    @IBOutlet weak var tableViewTest: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "ActiveDonationViewCell", bundle: nil)
        self.tableViewTest.register(cellNib, forCellReuseIdentifier: "charityCell")
        
        tableViewTest.delegate = self
        tableViewTest.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewTest.dequeueReusableCell(withIdentifier: "charityCell", for: indexPath) as! ActiveDonationViewCell
        
        //let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "testCell")!
        // Set text from the data model
        let character = sampleData[indexPath.row]
        
        cell.charityNameLabel.text = character["name"] as? String
        //cell.textLabel?.text = character["name"] as? String
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106.5
    }


}
