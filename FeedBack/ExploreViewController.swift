
import UIKit

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var contentTableView: UITableView!
    
    
    var charityCategories = [CharityCategory.animals, CharityCategory.enviromental, CharityCategory.health, CharityCategory.others]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTableView.delegate = self
        contentTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToCharitySelection", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath: IndexPath = sender as? IndexPath else { return }
        guard let charitySelectionVc: CharitySelectionViewController = segue.destination as? CharitySelectionViewController else{
            return
        }
        charitySelectionVc.charityCategory = charityCategories[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charityCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CharityCategoryTableViewCell", owner: self, options: nil)?.first as! CharityCategoryTableViewCell
        cell.charityTitleLabel.text = charityCategories[indexPath.row].rawValue.uppercased()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 158.5
    }
    
    

}



