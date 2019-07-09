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
    var userRef: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    var currentUser = Auth.auth().currentUser
    let leaderBoardTypes = [LeaderBoardTypes.GeoLeaderboard, LeaderBoardTypes.TotalLeaderBoard]
    var selectedLeaderBoard = LeaderBoardTypes.GeoLeaderboard
    var users = [User]()
    var usersFriends = [User]()
    var currentUserDb: User?
    var friendsUniqueIds = [Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        ref = Database.database().reference(withPath: usersPath)
        let query = ref.queryOrdered(byChild: levelPath)
        
        userRef = Database.database().reference(withPath: "users").child(currentUser!.uid)
        userRef.observe(DataEventType.value) { (snapshot) in
            guard let currentUserDb = User(snapshot: snapshot) else { return }
            self.currentUserDb = currentUserDb
            self.usersFriends = [User]() // reset array, update new snapshot
            if(!self.usersFriends.contains(where: { (user) -> Bool in
                user.uniqueId == currentUserDb.uniqueId
            })){
                self.usersFriends.append(currentUserDb)
                
            }
            
            self.friendsUniqueIds = currentUserDb.friendsHolder.friends
            self.leaderBoardTableView.reloadData()
            
            for friendId in self.friendsUniqueIds{
                let friendRef = Database.database().reference(withPath: "users").child(friendId.uniqueId)
                friendRef.observe(DataEventType.value) { (snapshot) in
                    guard let friendUser = User(snapshot: snapshot) else { return }
                    if(!self.usersFriends.contains(where: { (user) -> Bool in
                        user.uniqueId == friendUser.uniqueId
                    })){
                    self.usersFriends.append(friendUser)
                    self.leaderBoardTableView.reloadData()
                    }
                }
            }
        }
        
        query.observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                self.users = []
                for snap in snapshots {
                    let user = User(snapshot: snap)
                    if(user != nil){
                    self.users.insert(user!, at: 0)
                    }
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
        if(selectedLeaderBoard == .GeoLeaderboard){
            return usersFriends.count
        }
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(selectedLeaderBoard == .GeoLeaderboard){
            let cell = Bundle.main.loadNibNamed("RankedUserTableViewCell", owner: self, options: nil)?.first as! RankedUserTableViewCell
            let user = self.usersFriends.sorted(by: { $0.level > $1.level })[indexPath.row]
            let storageReference = Storage.storage().reference()
            let profileImageRef = storageReference.child(usersPath).child(user.uniqueId).child("\(user.uniqueId)-profileImage.jpg")
            let placeholderImage = UIImage(named: "user.png")
            cell.userAvatar.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
            cell.userAvatar.setRounded()
            cell.userNameLabel.text = user.userName
            cell.userPointsLabel.text = String(user.level)
            cell.uniqueUserId = user.uniqueId
            cell.userRankLabel.text = String(indexPath.row+1) + "."
            if(user.uniqueId == currentUser!.uid){
            cell.backgroundColor = UIColor.gray
            }
            return cell
        }else{
        
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
            if(user.uniqueId == currentUser!.uid){
                cell.backgroundColor = UIColor.lightGray
            }
        return cell
        }
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
                return "Friends"
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
