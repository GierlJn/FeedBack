
import UIKit

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var contentTableView: UITableView!
    
    var sampleData:[Dictionary<String, Any>] = [
        [
            "name": "Most Effective",
            "information" : "Because Aids is bad",
        ],
        [
            "name": "Animals",
            "information" : "Because Aids is bad",
        ],
        [
            "name": "Health",
            "information" : "Because Aids is bad",
        ],
        [
            "name": "Environmental",
            "information" : "Because Aids is bad",
        ]
    ]
    
    var selectionMode = SelectionMode.category
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let cellNib = UINib(nibName: "CharityCategoryTableViewCell", bundle: nil)
        //self.contentTableView.register(cellNib, forHeaderFooterViewReuseIdentifier: "hurensohnZelle123")
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleData.count
//        switch selectionMode{
//            case .category:
//                return sampleData.count
//            case .single:
//                return sampleData.count
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = contentTableView.dequeueReusableCell(withIdentifier: "hurensohnZelle123", for: indexPath) as! CharityCategoryTableViewCell
        let cell = Bundle.main.loadNibNamed("CharityCategoryTableViewCell", owner: self, options: nil)?.first as! CharityCategoryTableViewCell
        
        
        let charityCategory = sampleData[indexPath.row]
        cell.charityTitleLabel.text = charityCategory["name"] as? String
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 158.5
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


enum SelectionMode{
    case category, single
}
