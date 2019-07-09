
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
    @IBOutlet weak var achievementCollectionView: UICollectionView!
    @IBOutlet weak var impactTableView: UITableView!
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var donationTableView: UITableView!
    
    var userRef: DatabaseReference!
    var mappedDonations = [Donation]()
    var allDonations = [Donation]()
    var user: User?
    var friends = [Friend]()
    var achievements = [AchievementFirebaseEntry]()
    var currentUser = Auth.auth().currentUser
    let achievementManager = AchievementManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = Firebase.Auth.auth().currentUser else { return }
        userRef = Database.database().reference(withPath: "users").child(user.uid)
        userRef.observe(DataEventType.value) { (snapshot) in
            guard let user = User(snapshot: snapshot) else { return }
            self.user = user
            self.userNameLabel.text = String(user.userName)
            self.levelLabel.text = String(user.level)
            self.rankLabel.text = Level.getRankForLevel(level: user.level)
            self.donationSumLabel.text = currency + String(user.donationHolder.getTotalDonationSum())
            self.allDonations = user.donationHolder.donations
            self.mappedDonations = user.donationHolder.getMappedDonations()
            self.setupUserImage()
            self.friends = user.friendsHolder.friends
            self.achievements = user.achievementHolder.achievements
            self.impactTableView.reloadData()
            self.friendsTableView.reloadData()
            self.donationTableView.reloadData()
            self.achievementCollectionView.reloadData()
            
        }
        
        self.setupUserImage()
        setupCollectionView()
        setupImpactTableView()
        setupFriendsTableView()
        setupDonationTableView()
        setupSeperatorLines()
    }
    
    fileprivate func setupUserImage() {
        let storageReference = Storage.storage().reference()
        let profileImageRef = storageReference.child(usersPath).child(currentUser!.uid).child("\(currentUser!.uid)-profileImage.jpg")
        let placeholderImage = UIImage(named: "user.png")
        userImage.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
        userImage.setRounded()
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        var textToShare = ""
        for donation in mappedDonations{
            textToShare.append(donation.impactType.getimpactDescriptionStringBeforeValue() ?? "")
            textToShare.append(" ")
            textToShare.append(String(Int(Float(donation.impactAmount)!)))
            textToShare.append(" ")
            textToShare.append(donation.impactType.getimpactDescriptionStringAfterValue() ?? "")
            textToShare.append("\n")
        }
        textToShare.append("Keep track of your donations and compete with your friends: [inviteLink]")
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
    
    fileprivate func setupImpactTableView() {
        impactTableView.dataSource = self
        impactTableView.delegate = self
        impactTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    fileprivate func setupDonationTableView() {
        donationTableView.dataSource = self
        impactTableView.delegate = self
    }
    
    fileprivate func setupFriendsTableView(){
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievementManager.availableAchievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = achievementCollectionView.dequeueReusableCell(withReuseIdentifier: "achievementCell", for: indexPath) as! AchievementCell
        let achievementForCell = achievementManager.availableAchievements[indexPath.row]
        
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
        let achievement = achievementManager.availableAchievements[indexPath.row]
        if(userHasAchievement(achievementId: achievement.key)){
            let achievementWithDate = achievements.first { (entry) -> Bool in
                entry.id == achievement.key
            }
            let achievementAchievedDate = achievementWithDate?.getTimeStampAsString()
            let alert = UIAlertController(title: achievement.name, message: "\(achievement.messageWhenAchieved)\n\(achievementAchievedDate ?? "")", preferredStyle: .alert)
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
        if(self.achievements.contains(where: { (entry) -> Bool in
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
            return friends.count
        case donationTableView:
            return allDonations.count
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
        case donationTableView:
            let cell = Bundle.main.loadNibNamed("DonationTableTableViewCell", owner: self, options: nil)?.first as! DonationTableTableViewCell
            let donation = allDonations[indexPath.row]
            cell.amountLabel.text = String(donation.amount) + currency
            cell.recipientLabel.text = donation.name
            cell.dateLabel.text = donation.getTimeStampAsString()
            return cell
            
        default:
            return UITableViewCell()
        }
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
            //let settingsViewController = segue.destination as? SettingsViewController
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
