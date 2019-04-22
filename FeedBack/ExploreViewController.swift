
import UIKit

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var contentTableView: UITableView!
    
    
    var charityCategories = [CharityCategory(nameOfCategory: "Animals"), CharityCategory(nameOfCategory: "Health"), CharityCategory(nameOfCategory: "Enviromental"), CharityCategory(nameOfCategory: "Most Effective")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTableView.delegate = self
        contentTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentTableView.deselectRow(at: indexPath, animated: true)

        let controller : CharitySelectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "CharitySelectionViewController") as! CharitySelectionViewController
        
        controller.charityCategoryId = charityCategories[indexPath.row].nameOfCategory
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: false)
        }
        print("clicked : \(charityCategories[indexPath.row].nameOfCategory)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charityCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CharityCategoryTableViewCell", owner: self, options: nil)?.first as! CharityCategoryTableViewCell
        cell.charityTitleLabel.text = charityCategories[indexPath.row].nameOfCategory
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 158.5
    }

}



