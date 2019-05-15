
import UIKit
import Firebase

class CharitySelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var contentTableView: UITableView!
    
    var charityCategoryId = "mockupId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentTableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        
        let controller : CharityInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "CharityInfoViewController") as! CharityInfoViewController
        let charityCategory = CharitySample.sampleData[section]
        controller.charityName = charityCategory["name"] as! String
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: false)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CharitySample.sampleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CharityTableViewCell", owner: self, options: nil)?.first as! CharityTableViewCell
        let charity = CharitySample.sampleData[indexPath.row]
        
        cell.charityName.text = charity["name"] as? String
        cell.informationLabel.text = charity["information"] as? String
        cell.charityLogo.image = charity["picture"] as? UIImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.5
    }
    
}
