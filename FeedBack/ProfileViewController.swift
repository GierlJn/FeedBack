
import UIKit
import Firebase
import FirebaseUI

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var donationSumLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var achievementView: UIView!
    @IBOutlet weak var impactView: UIView!
    @IBOutlet weak var userProfileView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var impactTableView: UITableView!
    @IBOutlet weak var achievementCollectionView: UICollectionView!
    @IBOutlet weak var friendsTableView: UITableView!
    
    var userRef: DatabaseReference!
    var mappedDonations = [GameDonation]()
    var allDonations = [GameDonation]()
    var user: User?
    var friends: [Friend]?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let user = Firebase.Auth.auth().currentUser else { return }
        userRef = Database.database().reference(withPath: "users").child(user.uid)
        userRef.observe(DataEventType.value) { (snapshot) in
            guard let user = User(snapshot: snapshot) else { return }
            self.user = user
            self.userNameLabel.text = String(user.userName)
            self.levelLabel.text = String(user.level)
            self.rankLabel.text = Level.getRankForLevel(level: user.level)
            self.donationSumLabel.text = String(user.donationHolder.getTotalDonationSum()) + " " + currency
            self.allDonations = user.donationHolder.donations
            self.mappedDonations = user.donationHolder.getMappedDonations()
            self.setupUserImage()
            self.friends = user.friendsHolder.friends
            self.impactTableView.reloadData()
            self.friendsTableView.reloadData()
        }
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

    
    let sampleAchievements = [AchievementModel(image: UIImage(imageLiteralResourceName: "medal-2.png"), title: "Humanitarian"), AchievementModel(image: UIImage(imageLiteralResourceName: "heart_achievement.png"), title: "Sharing is caring"), AchievementModel(image: UIImage(imageLiteralResourceName: "like.png"), title: "You're awesome!")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupTableView()
        setupFriendsTableView()
        setupSeperatorLines()
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        var textToShare = ""
        for donation in mappedDonations{
            textToShare.append(donation.impactType.getimpactDescriptionStringBeforeValue() + " ")
            textToShare.append(String(Int(Float(donation.impactAmount)!)))
            textToShare.append(" " + donation.impactType.getimpactDescriptionStringAfterValue())
            textToShare.append("\n")
        }
        textToShare.append("\n\nKeep track of your donations and compete with your friends: [inviteLink]")
        showShareActivityOptions(textToShare)
    }
    
    
    fileprivate func showShareActivityOptions(_ text: String) {
        let textToShare = [ text ]
        let activityController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        if let popoverController = activityController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        activityController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
        self.present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func addFriendsButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let inviteFriendsAction = UIAlertAction(title: "Invite friends", style: .default) { (action) in
            self.showShareActivityOptions("Come join me: [inviteLink]")
        }
        alertController.addAction(inviteFriendsAction)
        let searchForFriendsAction = UIAlertAction(title: "Search for friends", style: .default) { (action) in
            self.performSegue(withIdentifier: "addFriendsSegue", sender: self)
        }
        alertController.addAction(searchForFriendsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            return
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
        return sampleAchievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = achievementCollectionView.dequeueReusableCell(withReuseIdentifier: "achievementCell", for: indexPath) as! AchievementCell
        
        cell.achievementImage.image = sampleAchievements[indexPath.row].image
        cell.achievementTitle.text = sampleAchievements[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == impactTableView){
            return mappedDonations.count
        } else if (tableView == friendsTableView){
            guard let friends = friends else { return 0 }
            return friends.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (tableView == impactTableView){
            let cell = Bundle.main.loadNibNamed("ImpactTableViewCell", owner: self, options: nil)?.first as! ImpactTableViewCell
            let donation = mappedDonations[indexPath.row]
            cell.impactNameLabel.text = donation.impactType.getimpactDescriptionStringBeforeValue()
            cell.impactLabel.text = String(Int(Float(donation.impactAmount)!))
            cell.afterImpactLabel.text = donation.impactType.getimpactDescriptionStringAfterValue()
            return cell
        } else if (tableView == friendsTableView){
            let cell = Bundle.main.loadNibNamed("FriendTableViewCell", owner: self, options: nil)?.first as! FriendTableViewCell
            guard let friends = friends else { return cell }
            let friend = friends[indexPath.row]
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
            }
        return UITableViewCell()
    }

    
    @IBAction func settingsButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "showSettingsSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == friendsTableView){
        performSegue(withIdentifier: "goToPublicUserProfile", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showSettingsSegue"){
            let settingsViewController = segue.destination as? SettingsViewController
        }else if (segue.identifier == "goToPublicUserProfile"){
            guard let indexPath: IndexPath = sender as? IndexPath else { return }
            guard let publicUserProfileViewController = segue.destination as? PublicUserProfileViewController else{
                return
            }
            let selectedCell = friendsTableView.cellForRow(at: indexPath) as! FriendTableViewCell
            publicUserProfileViewController.userId = selectedCell.uniqueId
        }
    }
}
