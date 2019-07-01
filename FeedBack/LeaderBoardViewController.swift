import UIKit
import Firebase
import FirebaseUI

enum LeaderBoardTypes{
    case GeoLeaderboard, TotalLeaderBoard
}

class LeaderBoardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var typeOfLeaderBoardPickerView: UIPickerView!
    @IBOutlet weak var leaderBoardTableView: UITableView!
    @IBOutlet weak var selectionUIView: UIView!
    var ref: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    var currentUser = Auth.auth().currentUser
    let leaderBoardTypes = [LeaderBoardTypes.GeoLeaderboard, LeaderBoardTypes.TotalLeaderBoard]
    var selectedLeaderBoard = LeaderBoardTypes.TotalLeaderBoard
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        ref = Database.database().reference(withPath: usersPath)
        let query = ref.queryOrdered(byChild: levelPath).queryLimited(toLast: 5)
        
        query.observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                self.users = []
                for snap in snapshots {
                    let user = User(snapshot: snap)
                    self.users.insert(user!, at: 0)
                    }
                }
                self.leaderBoardTableView.reloadData()
            })
        setViewBorders()
        leaderBoardTableView.dataSource = self
        leaderBoardTableView.delegate = self
    }
    
    private func setupPickerView(){
        typeOfLeaderBoardPickerView.dataSource = self
        typeOfLeaderBoardPickerView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("RankedUserTableViewCell", owner: self, options: nil)?.first as! RankedUserTableViewCell
        let user = users[indexPath.row]
        let storageReference = Storage.storage().reference()
        let profileImageRef = storageReference.child(usersPath).child(user.uniqueId).child("\(user.uniqueId)-profileImage.jpg")
        let placeholderImage = UIImage(named: "user.png")
        cell.userAvatar.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
        cell.userAvatar.setRounded()
        cell.userNameLabel.text = user.userName
        cell.userPointsLabel.text = String(user.level)
        cell.uniqueUserId = user.uniqueId
        cell.userRankLabel.text = String(indexPath.row+1) + "."
        return cell
    }
    
    private func setViewBorders(){
        let bottomBorder: CALayer = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: selectionUIView.frame.size.height+2, width: selectionUIView.frame.size.width, height: 2)
        bottomBorder.backgroundColor = UIColor.purple.cgColor
        selectionUIView.layer.addSublayer(bottomBorder)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return leaderBoardTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch(leaderBoardTypes[row]){
            case .GeoLeaderboard:
                return "Local"
            case .TotalLeaderBoard:
                return "Global"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch(leaderBoardTypes[row]){
            case .GeoLeaderboard:
                selectedLeaderBoard = .GeoLeaderboard
            case .TotalLeaderBoard:
                selectedLeaderBoard = .TotalLeaderBoard
        }
        leaderBoardTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPublicProfile", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath: IndexPath = sender as? IndexPath else { return }
        guard let destinationVc: PublicUserProfileViewController = segue.destination as? PublicUserProfileViewController else{
            return
        }
        let cell = leaderBoardTableView.cellForRow(at: indexPath) as! RankedUserTableViewCell
        guard let userId = cell.uniqueUserId else { return }
        destinationVc.userId = userId
    }

}
