//
//  GameViewController.swift
//  FeedBack
//
//  Created by Julian on 08.04.19.
//  Copyright © 2019 gierljn. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableViewTest: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewTest.register(UITableViewCell.self, forCellReuseIdentifier: "testCell")
        tableViewTest.delegate = self
        tableViewTest.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "testCell")!
        // Set text from the data model
        cell.textLabel?.text = "123123123"
        return cell
    }

}
