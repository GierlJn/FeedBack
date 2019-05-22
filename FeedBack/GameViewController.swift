
import UIKit
import Firebase
import FirebaseUI

class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //TODO: differnent name
    @IBOutlet weak var avatarPicture: UIImageView!
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var donationSumLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    var userRef: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    var user: Firebase.User?
    var mappedDonations = [GameDonation]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = Firebase.Auth.auth().currentUser else { return }
        userRef = Database.database().reference(withPath: "users").child(user.uid)
        userRef.observe(DataEventType.value) { (snapshot) in
            guard let user = User(snapshot: snapshot) else { return }
            self.levelLabel.text = String(user.level)
            let rank = Level.getRankForLevel(level: user.level)
            self.rankLabel.text = rank
            self.donationSumLabel.text = String(user.donationHolder.getTotalDonationSum())
            self.mappedDonations = user.donationHolder.getMappedDonations()
            print(user.donationHolder.getMappedDonations())
            self.gameTableView.reloadData()
        }
        
        gameTableView.delegate = self
        gameTableView.dataSource = self
        setupBottomBorder()
    }
    
    fileprivate func setupBottomBorder() {
        let bottomBorder: CALayer = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: userView.frame.size.height+2, width: userView.frame.size.width, height: 2)
        bottomBorder.backgroundColor = UIColor.purple.cgColor
        userView.layer.addSublayer(bottomBorder)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mappedDonations.count+1
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
        let donationCellContent = mappedDonations[indexPath.row]
        cell.charityNameLabel.text = donationCellContent.name
        
        var impactTypeText = ""
        switch(donationCellContent.impactType){
        case .childTreated:
            impactTypeText = "Children treated"
        case .netFounded:
            impactTypeText = "Malaria nets funded"
        case .ntdTreated:
            impactTypeText = "NTD's treated"
        case .none:
            impactTypeText = ""
        }
        cell.statsSumLabel.text = impactTypeText
        cell.statsSumInNumbers.text = donationCellContent.impactAmount
        cell.charityAvatar.image = donationCellContent.getLogoImage()
        
        //let level = Level.getLevelForChildrenTreated(for: Int(Float(donationCellContent.impactAmount)!))
        let level = donationCellContent.getLevelForImpactAmount()
        //TODO GET LEVELS For each category
        cell.levelLabel.text = String(level)
        let progress = Level.getProgressUntilNextLevel(for: Float(donationCellContent.impactAmount)!)
        cell.monthlyProgress.progress = progress
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129.5
    }
    

}
