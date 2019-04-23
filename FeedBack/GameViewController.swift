
import UIKit

class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var avatarPicture: UIImageView!
    @IBOutlet weak var tableViewTest: UITableView!
    @IBOutlet weak var userView: UIView!
    
    @IBOutlet weak var donationSumLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewTest.delegate = self
        tableViewTest.dataSource = self
        
        setupBottomBorder()
    }
    
    fileprivate func setupBottomBorder() {
        let bottomBorder: CALayer = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: userView.frame.size.height+2, width: userView.frame.size.width, height: 2)
        bottomBorder.backgroundColor = UIColor.purple.cgColor
        userView.layer.addSublayer(bottomBorder)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Charity.sampleData.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = Bundle.main.loadNibNamed("ActiveDonationViewCell", owner: self, options: nil)?.first as! ActiveDonationViewCell
        let lastCell = Bundle.main.loadNibNamed("LastActiveDonationTableViewCell", owner: self, options: nil)?.first as! LastActiveDonationTableViewCell
        
        let totalRow =
            tableView.numberOfRows(inSection: indexPath.section)
        if(indexPath.row == totalRow - 1)
        {
            return lastCell
        }
        
        let character = Charity.sampleData[indexPath.row]
        
        cell.charityNameLabel.text = character["name"] as? String
        cell.charityAvatar.image = character["picture"] as? UIImage
        cell.monthlyProgress.progress = (character["progress"] as? Float)!
        cell.levelLabel.text = character["points"] as? String
        cell.statsInfoLabel.text = character["statsInfo"] as? String
        cell.statsSumLabel.text = character["statsSum"] as? String
        cell.statsSumInNumbers.text = character["statsSumMock"] as? String
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129.5
    }


}
