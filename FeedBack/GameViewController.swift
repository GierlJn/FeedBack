
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
    
    var ref: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    var user: Firebase.User?
    var allDonations = [GameDonation]()
    var mappedDonations = [GameDonation]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = Firebase.Auth.auth().currentUser else { return }
        ref = Database.database().reference(withPath: "users").child(user.uid).child("donations")
        ref.observe(DataEventType.value) { (snapshot) in
            for case let donationSnapshot as DataSnapshot in snapshot.children{
                guard let gameDonation = GameDonation(snapshot: donationSnapshot) else { return }
                self.allDonations.append(gameDonation)
            }
            self.mapDonations()
        }
        gameTableView.delegate = self
        gameTableView.dataSource = self
        setupBottomBorder()
    }
    
    func mapDonations(){
        for impactType in CharityImpactType.allValues{
            print(impactType)
            let donationsForImpactType = allDonations.filter{
                return $0.impactType == impactType }
            let sum: Float = donationsForImpactType.reduce(0.0) { (result: Float, donation: GameDonation) -> Float in
                return result + Float(donation.impactAmount)!
            }
            if(!donationsForImpactType.isEmpty){
            let charityName: String = donationsForImpactType[0].name // to be changed, impacttypes can have different charities
            let mappedDonation = GameDonation(name: charityName, impactType: impactType, impactAmount: String(sum))
            mappedDonations.append(mappedDonation)
            gameTableView.reloadData()
            }
        }
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
        //let character = CharitySample.sampleData[indexPath.row]
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
        
        //cell.statsSumLabel
        //cell.charityNameLabel.text = character["name"] as? String
        //cell.charityAvatar.image = character["picture"] as? UIImage
        //cell.monthlyProgress.progress = (character["progress"] as? Float)!
        //cell.levelLabel.text = character["points"] as? String
        //cell.statsInfoLabel.text = character["statsInfo"] as? String
        //cell.statsSumLabel.text = character["statsSum"] as? String
        //cell.statsSumInNumbers.text = character["statsSumMock"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129.5
    }


}
