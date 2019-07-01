
import UIKit
import Firebase
import FirebaseUI

class PublicUserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var achievementView: UIView!
    @IBOutlet weak var impactView: UIView!
    @IBOutlet weak var userProfileView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var impactTableView: UITableView!
    @IBOutlet weak var achievementCollectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addFriendButtonOutlet: UIButton!
    @IBOutlet weak var friendsTableView: UITableView!
    
    var userRef: DatabaseReference!
    var userFriends = [Friend]()
    var mappedDonations = [Donation]()
    var allDonations = [Donation]()
    var userId: String?
    var user: User?
    var currentUserLogin = Auth.auth().currentUser
    var currentUser: User?
    var currentUserRef: DatabaseReference!
    var currentUserFriends: [Friend]?
    var firebaseAchievementEntries = [AchievementFirebaseEntry]()
    let allAchievements = Achievements.getAllAvailableAchievements()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUserLogin = currentUserLogin else { return }
        guard let userId = userId else { return }
        userRef = Database.database().reference(withPath: usersPath).child(userId)
        userRef.observe(DataEventType.value) { (snapshot) in
            guard let user = User(snapshot: snapshot) else { return }
            self.user = user
            if(user.uniqueId == currentUserLogin.uid){
                self.addFriendButtonOutlet.isHidden = true
            }
            self.userNameLabel.text = String(user.userName)
            self.levelLabel.text = String(user.level)
            self.rankLabel.text = Level.getRankForLevel(level: user.level)
            self.allDonations = user.donationHolder.donations
            self.mappedDonations = user.donationHolder.getMappedDonations()
            self.setupUserImage()
            self.userFriends = user.friendsHolder.friends
            self.firebaseAchievementEntries = user.achievementHolder.achievements
            self.friendsTableView.reloadData()
            self.impactTableView.reloadData()
            self.achievementCollectionView.reloadData()
        }
        
        currentUserRef = Database.database().reference(withPath: usersPath).child(currentUserLogin.uid)
        currentUserRef.observe(DataEventType.value) { (snapshot) in
            guard let currentUser = User(snapshot: snapshot) else { return }
            self.currentUser = currentUser
            self.currentUserFriends = currentUser.friendsHolder.friends
            self.updateAddFriendButton()
        }
        
        setupCollectionView()
        setupTableView()
        setupSeperatorLines()
        setupFriendsTableView()
    }
    
    fileprivate func setupUserImage() {
        let storageReference = Storage.storage().reference()
        let profileImageRef = storageReference.child(usersPath).child(user!.uniqueId).child("\(user!.uniqueId)-profileImage.jpg")
        let placeholderImage = UIImage(named: "user.png")
        userImage.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
        userImage.setRounded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    @IBAction func addAsFriendButton(_ sender: Any) {
        if(userIsAddedAsFriend()){
            print("remove friend")
            removeFriend()
        }else{
            print("add friend")
            addFriend()
        }
        updateAddFriendButton()
    }
    
    func addFriend(){
        let updateValues = [user!.uniqueId:"true"] as [String:Any]
        currentUserRef.child("friends").updateChildValues(updateValues)
    }
    
    func removeFriend(){
        currentUserRef.child("friends").child(user!.uniqueId).removeValue()
    }

    
    fileprivate func updateAddFriendButton(){
        if(userIsAddedAsFriend()){
            addFriendButtonOutlet.setTitle("Remove friend", for: .normal)
        }else{
            addFriendButtonOutlet.setTitle("Add as friend", for: .normal)
        }
    }
    
    fileprivate func userIsAddedAsFriend()->Bool{
        if(self.currentUserFriends!.contains(where: { (friend) -> Bool in
            friend.uniqueId == user?.uniqueId
        })){
            return true
        }else{
            return false
        }
    }
    
    fileprivate func setupSeperatorLines(){
        setupBottomBorder(for: userProfileView)
        setupBottomBorder(for: impactView)
        setupBottomBorder(for: achievementView)
        setupBottomBorder(for: friendView)
    }
    
    fileprivate func setupBottomBorder(for view: UIView) {
        let bottomBorder: CALayer = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: view.frame.size.height+1, width: view.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.purple.cgColor
        view.layer.addSublayer(bottomBorder)
    }
    
    fileprivate func setupCollectionView() {
        achievementCollectionView.dataSource = self
        achievementCollectionView.delegate = self
        achievementCollectionView.register(UINib.init(nibName: "AchievementCell", bundle: nil), forCellWithReuseIdentifier: "achievementCell")
    }
    
    fileprivate func setupTableView() {
        impactTableView.dataSource = self
        impactTableView.delegate = self
        impactTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    fileprivate func setupFriendsTableView(){
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allAchievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = achievementCollectionView.dequeueReusableCell(withReuseIdentifier: "achievementCell", for: indexPath) as! AchievementCell
        let achievementForCell = allAchievements[indexPath.row]
        
        if(!userHasAchievement(achievementId: achievementForCell.key)){
            cell.achievementImage.alpha = 0.3
            cell.achievementTitle.alpha = 0.3
        }else{
            cell.achievementImage.alpha = 1
            cell.achievementTitle.alpha = 1
        }
        
        cell.achievementImage.image = achievementForCell.image
        cell.achievementTitle.text = achievementForCell.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let achievement = allAchievements[indexPath.row]
        if(userHasAchievement(achievementId: achievement.key)){
            let achievementWithDate = firebaseAchievementEntries.first { (entry) -> Bool in
                entry.id == achievement.key
            }
            let achievementAchievedDate = achievementWithDate?.getTimeStampAsString()
            let alert = UIAlertController(title: achievement.name, message: "\(achievement.description)\n\(achievementAchievedDate ?? "")", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: achievement.name, message: "\(achievement.description)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func userHasAchievement(achievementId: String)->Bool{
        if(self.firebaseAchievementEntries.contains(where: { (entry) -> Bool in
            entry.id == achievementId
        })){
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(tableView){
        case impactTableView:
            return mappedDonations.count
        case friendsTableView:
            return userFriends.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(tableView){
        case impactTableView:
            let cell = Bundle.main.loadNibNamed("ImpactTableViewCell", owner: self, options: nil)?.first as! ImpactTableViewCell
            let donation = mappedDonations[indexPath.row]
            cell.impactNameLabel.text = donation.impactType.getimpactDescriptionStringBeforeValue()
            cell.impactLabel.text = String(Int(Float(donation.impactAmount)!))
            cell.afterImpactLabel.text = donation.impactType.getimpactDescriptionStringAfterValue()
            return cell
        case friendsTableView:
            let cell = Bundle.main.loadNibNamed("FriendTableViewCell", owner: self, options: nil)?.first as! FriendTableViewCell
            let friend = userFriends[indexPath.row]
            let friendRef = Database.database().reference(withPath: "users").child(friend.uniqueId)
            friendRef.observe(DataEventType.value) { (snapshot) in
                guard let friendUser = User(snapshot: snapshot) else { return }
                cell.uniqueId = friend.uniqueId
                cell.userNameLabel.text = friendUser.userName
                cell.userLevelLabel.text = String(friendUser.level)
                let storageReference = Storage.storage().reference()
                let profileImageRef = storageReference.child(usersPath).child(friend.uniqueId).child("\(friend.uniqueId)-profileImage.jpg")
                let placeholderImage = UIImage(named: "user.png")
                cell.userImage.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
                cell.userImage.setRounded()
            }
            return cell
        default:
            return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if(tableView == friendsTableView){
           // performSegue(withIdentifier: "loadNewProfile", sender: indexPath)
        //}
        let selectedCell = friendsTableView.cellForRow(at: indexPath) as! FriendTableViewCell
        //            publicUserProfileViewController.userId = selectedCell.uniqueId
        
        let vc:PublicUserProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "publicUserProfie") as! PublicUserProfileViewController
        vc.userId = selectedCell.uniqueId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "goToPublicUserProfile"){
//            guard let indexPath: IndexPath = sender as? IndexPath else { return }
//            guard let publicUserProfileViewController = segue.destination as? PublicUserProfileViewController else{
//                return
//            }
//            let selectedCell = friendsTableView.cellForRow(at: indexPath) as! FriendTableViewCell
//            publicUserProfileViewController.userId = selectedCell.uniqueId
//        }
//    }
//
//   // @IBAction func dismissVc(_ sender: Any) {
//       // self.dismiss(animated: true, completion: nil)
//    //}
//}

