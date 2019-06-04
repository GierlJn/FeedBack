
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
    
    var userRef: DatabaseReference!
    var userFriends: [Friend]?
    var mappedDonations = [GameDonation]()
    var allDonations = [GameDonation]()
    var userId: String?
    var user: User?
    
    var currentUserLogin = Auth.auth().currentUser
    var currentUser: User?
    var currentUserRef: DatabaseReference!
    var currentUserFriends: [Friend]?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
    
    
    let sampleAchievements = [AchievementModel(image: UIImage(imageLiteralResourceName: "medal-2.png"), title: "Humanitarian"), AchievementModel(image: UIImage(imageLiteralResourceName: "heart_achievement.png"), title: "Sharing is caring"), AchievementModel(image: UIImage(imageLiteralResourceName: "like.png"), title: "You're awesome!")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUserLogin = currentUserLogin else { return }
        
        guard let userId = userId else { return }
        userRef = Database.database().reference(withPath: usersPath).child(userId)
        userRef.observe(DataEventType.value) { (snapshot) in
            guard let user = User(snapshot: snapshot) else { return }
            self.user = user
            self.userNameLabel.text = String(user.userName)
            self.levelLabel.text = String(user.level)
            self.rankLabel.text = Level.getRankForLevel(level: user.level)
            self.allDonations = user.donationHolder.donations
            self.mappedDonations = user.donationHolder.getMappedDonations()
            self.setupUserImage()
            self.impactTableView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleAchievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = achievementCollectionView.dequeueReusableCell(withReuseIdentifier: "achievementCell", for: indexPath) as! AchievementCell
        cell.achievementImage.image = sampleAchievements[indexPath.row].image
        cell.achievementTitle.text = sampleAchievements[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mappedDonations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ImpactTableViewCell", owner: self, options: nil)?.first as! ImpactTableViewCell
        let donation = mappedDonations[indexPath.row]
        cell.impactNameLabel.text = donation.impactType.getimpactDescriptionStringBeforeValue()
        cell.impactLabel.text = String(Int(Float(donation.impactAmount)!))
        cell.afterImpactLabel.text = donation.impactType.getimpactDescriptionStringAfterValue()
        return cell
    }
    
    @IBAction func dismissVc(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

