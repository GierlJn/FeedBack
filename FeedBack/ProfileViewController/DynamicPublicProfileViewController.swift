
import UIKit
import Firebase

class DynamicPublicProfileViewController: UIViewController{
    
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userLevel: UILabel!
    @IBOutlet weak var userRankLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var achievementCollectionView: UICollectionView!
    @IBOutlet weak var addFriendButtonOutlet: UIButton!
    
    let currentUser = Auth.auth().currentUser
    var userId: String?
    var user: User?
    let achievementCollectionViewProvider = AchievementCollectionViewProvider()
    var currentUserFriends: [Friend]?
    var currentUserRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureAddFriendButton()
        setupCollectionView()
        guard let userId = userId else { return }
        let userManager = UserManager()
        userManager.delegate = self
        userManager.observeUserData(forUser: userId)
        
    }
    
    fileprivate func configureTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    fileprivate func configureAddFriendButton(){
        guard let currentUser = currentUser else { return }
        currentUserRef = Database.database().reference(withPath: usersPath).child(currentUser.uid)
        currentUserRef.observe(DataEventType.value) { (snapshot) in
            guard let currentUser = User(snapshot: snapshot) else { return }
            self.currentUserFriends = currentUser.friendsHolder.friends
            self.updateAddFriendButton()
        }
    }
    
    fileprivate func setupCollectionView() {
        achievementCollectionView.dataSource = achievementCollectionViewProvider
        achievementCollectionView.delegate = achievementCollectionViewProvider
        achievementCollectionView.register(UINib.init(nibName: "AchievementCell", bundle: nil), forCellWithReuseIdentifier: AchievementCell.identifier)
    }
    
    func configureUserInfo(){
        guard let user = user else { return }
        self.userNameLabel.text = String(user.userName)
        self.userLevel.text = String(user.level)
        self.userRankLabel.text = Level.getRankForLevel(level: user.level)
        self.userAvatar.setUserImage(userId: user.uniqueId)
        
        if(user.uniqueId == currentUser!.uid){
            self.addFriendButtonOutlet.isHidden = true
        }
    }
    
    fileprivate func updateAddFriendButton(){
        print("updateAddFriendButton")
        if(userIsAddedAsFriend()){
            addFriendButtonOutlet.setTitle("Remove friend", for: .normal)
        }else{
            addFriendButtonOutlet.setTitle("Add as friend", for: .normal)
        }
    }
    
    fileprivate func userIsAddedAsFriend()->Bool{
        print(user?.uniqueId)
        if(self.currentUserFriends!.contains(where: { (friend) -> Bool in
            friend.uniqueId == userId
        })){
            print("treu")
            return true
        }else{
            print("false")
            return false
        }
    }
    
    @IBAction func addAsFriendButtonPressed(_ sender: Any) {
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
    
    
    
}

extension DynamicPublicProfileViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName: String
        switch section {
        case 0:
            if(user?.donationHolder.donations.count == 0){
                return nil
            }
            sectionName = NSLocalizedString("Impact summary", comment: "")
        case 2:
            sectionName = NSLocalizedString("Friends", comment: "")
        case 1:
            if(user?.donationHolder.donations.count == 0){
                return nil
            }
            sectionName = NSLocalizedString("Donations", comment: "")
        default:
            sectionName = ""
        }
        return sectionName
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return user?.donationHolder.getMappedDonations().count ?? 0
        case 2:
            return user?.friendsHolder.friends.count ?? 0
        case 1:
            return user?.donationHolder.donations.count ?? 0
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = Bundle.main.loadNibNamed(ImpactTableViewCell.identifier, owner: self, options: nil)?.first as! ImpactTableViewCell
            guard let donation = user?.donationHolder.getMappedDonations()[indexPath.row] else{
                assertionFailure("weird error")
                return UITableViewCell()
            }
            cell.configure(for: donation)
            return cell
            
        case 2:
            let cell = Bundle.main.loadNibNamed(FriendTableViewCell.identifier, owner: self, options: nil)?.first as! FriendTableViewCell
            guard let friend = user?.friendsHolder.friends[indexPath.row] else{
                assertionFailure("weird error")
                return UITableViewCell()
            }
            let friendRef = Database.database().reference(withPath: "users").child(friend.uniqueId)
            friendRef.observe(DataEventType.value) { (snapshot) in
                guard let friendUser = User(snapshot: snapshot) else { return }
                cell.configure(for: friendUser)
            }
            return cell
            
        case 1:
            let cell = Bundle.main.loadNibNamed(DonationTableTableViewCell.identifier, owner: self, options: nil)?.first as! DonationTableTableViewCell
            guard let donation = user?.donationHolder.donations[indexPath.row] else{
                assertionFailure("weird error")
                return UITableViewCell()
            }
            cell.configure(for: donation)
            return cell
            
        default:
            fatalError()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToPublicUserProfile"){
            guard let indexPath: IndexPath = sender as? IndexPath else { return }
            guard let publicUserProfileViewController = segue.destination as? DynamicPublicProfileViewController else{
                return
            }
            let selectedCell = tableView.cellForRow(at: indexPath) as! FriendTableViewCell
            publicUserProfileViewController.userId = selectedCell.uniqueId
        }
    }
}

extension DynamicPublicProfileViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 2){
            let selectedCell = tableView.cellForRow(at: indexPath) as! FriendTableViewCell
            
            let vc:DynamicPublicProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "dynamicPublicUserProfie") as! DynamicPublicProfileViewController
            vc.userId = selectedCell.uniqueId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension DynamicPublicProfileViewController: UserManagerDelegate{
    func userDataUpdated(user: User) {
        self.user = user
        configureUserInfo()
        achievementCollectionViewProvider.userDataUpdated(achievements: user.achievementHolder.achievements)
        tableView.reloadData()
        achievementCollectionView.reloadData()
    }
}

