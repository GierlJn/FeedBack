
import UIKit

class CharitySelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var contentTableView: UITableView!
    
    var sampleData:[Dictionary<String, Any>] = [
        [
            "picture": #imageLiteral(resourceName: "wolf"),
            "name" : "NightSaver",
            "progress" : Float(0.33),
            "points" : "12",
            "information" : "NightSaver NightSaverNightSaverNightSaver NightSaverNightSaver",
        ],
        [
            "picture": #imageLiteral(resourceName: "lion"),
            "name" : "Lannister Foundation",
            "progress" : Float(0.7),
            "points" :  "44",
            "information" : "Lannister FoundationLannister FoundationLannister FoundationLannister Foundation",
        ],
        [
            "picture": #imageLiteral(resourceName: "dragon"),
            "name" : "Feeding Dragons",
            "progress" : Float(0.2),
            "points" :  "88",
            "information" : "Feeding DragonsFeeding DragonsFeeding DragonsFeeding DragonsFeeding DragonsFeeding Dragons",
        ]
    ]
    
    var charityCategoryId = "mockupId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTableView.delegate = self
        contentTableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CharityTableViewCell", owner: self, options: nil)?.first as! CharityTableViewCell
        let charity = sampleData[indexPath.row]
        
        cell.charityName.text = charity["name"] as? String
        cell.informationLabel.text = charity["information"] as? String
        cell.charityLogo.image = charity["picture"] as? UIImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.5
    }
    
}
