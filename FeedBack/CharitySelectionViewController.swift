
import UIKit
import Firebase
import FirebaseUI

class CharitySelectionViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var contentTableView: UITableView!
    var charityCategory: CharityCategory?
    
    var ref: DatabaseReference!
    
    var dataSource: FUITableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: charityPath)
        dataSource = FUITableViewDataSource(query: getQuery(), populateCell: { (contentTableView, indexPath, snap) -> UITableViewCell in
            let cell = Bundle.main.loadNibNamed("CharityTableViewCell", owner: self, options: nil)?.first as! CharityTableViewCell
            guard let charity = Charity(snapshot: snap) else { return cell }
            cell.charityImage.image = UIImage(named: "malaria_consortium_logo")
            cell.nameLabel.text = charity.name
            return cell
        })
        
        dataSource?.bind(to: contentTableView)
        contentTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.5
    }
    
    func getQuery() -> DatabaseQuery {
        return self.ref.queryOrdered(byChild: "category").queryEqual(toValue: charityCategory?.rawValue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getQuery().removeAllObservers()
    }
}
