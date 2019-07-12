
import UIKit
import Firebase
import FirebaseUI


class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserManagerDelegate{
 
    @IBOutlet weak var donationSumLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var friendView: ProfileSubView!
    @IBOutlet weak var achievementView: ProfileSubView!
    @IBOutlet weak var impactView: ProfileSubView!
    @IBOutlet weak var userProfileView: ProfileSubView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var achievementCollectionView: UICollectionView!
    @IBOutlet weak var impactTableView: UITableView!
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var donationTableView: UITableView!
    
    var user: User?
    var achievementProvider: AchievementProvider?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = Auth.auth().currentUser else { return }
        let userManager = UserManager()
        userManager.delegate = self
        userManager.observeUserData(forUser: currentUser.uid)
        achievementProvider = AchievementProvider(userManager: userManager)
        userImage.setUserImage(userId: currentUser.uid)
        setupCollectionView()
        setupImpactTableView()
        setupFriendsTableView()
        setupDonationTableView()
    }
    
    internal func userDataUpdated(user: User) {
        self.user = user
        self.achievementProvider?.userDataUpdated(user: user)
        self.userNameLabel.text = String(user.userName)
        self.levelLabel.text = String(user.level)
        self.rankLabel.text = Level.getRankForLevel(level: user.level)
        self.donationSumLabel.text = currency + String(user.donationHolder.getTotalDonationSum())
        self.userImage.setUserImage(userId: user.uniqueId)
        self.impactTableView.reloadData()
        self.friendsTableView.reloadData()
        self.donationTableView.reloadData()
        self.achievementCollectionView.reloadData()
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        showShareActivityOptions(generateTextToShare())
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
    
    fileprivate func generateTextToShare()->String{
        var textToShare = ""
        guard let mappedDonations = user?.donationHolder.getMappedDonations() else { return textToShare}
        for donation in mappedDonations{
            textToShare.append(donation.impactType.getimpactDescriptionStringBeforeValue() ?? "")
            textToShare.append(" ")
            textToShare.append(String(Int(Float(donation.impactAmount)!)))
            textToShare.append(" ")
            textToShare.append(donation.impactType.getimpactDescriptionStringAfterValue() ?? "")
            textToShare.append("\n")
        }
        textToShare.append("Keep track of your donations and compete with your friends: [inviteLink]")
        return textToShare
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
        userProfileView.addBottomBorder()
        impactView.addBottomBorder()
        achievementView.addBottomBorder()
        friendView.addBottomBorder()
    }
    
    
    fileprivate func setupCollectionView() {
        achievementCollectionView.dataSource = achievementProvider
        achievementCollectionView.delegate = achievementProvider
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(tableView){
        case impactTableView:
            return user?.donationHolder.getMappedDonations().count ?? 0
        case friendsTableView:
            return user?.friendsHolder.friends.count ?? 0
        case donationTableView:
            return user?.donationHolder.donations.count ?? 0
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(tableView){
        case impactTableView:
            let cell = Bundle.main.loadNibNamed("ImpactTableViewCell", owner: self, options: nil)?.first as! ImpactTableViewCell
            guard let mappedDonations = user?.donationHolder.getMappedDonations() else { return cell}
            let donation = mappedDonations[indexPath.row]
            cell.impactNameLabel.text = donation.impactType.getimpactDescriptionStringBeforeValue()
            cell.impactLabel.text = String(Int(Float(donation.impactAmount)!))
            cell.afterImpactLabel.text = donation.impactType.getimpactDescriptionStringAfterValue()
            return cell
        case friendsTableView:
            let cell = Bundle.main.loadNibNamed("FriendTableViewCell", owner: self, options: nil)?.first as! FriendTableViewCell
            guard let friends = user?.friendsHolder.friends else { return cell}
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
            guard let allDonations = user?.donationHolder.donations else { return cell}
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
        if (segue.identifier == "goToPublicUserProfile"){
            guard let indexPath: IndexPath = sender as? IndexPath else { return }
            guard let publicUserProfileViewController = segue.destination as? PublicUserProfileViewController else{
                return
            }
            let selectedCell = friendsTableView.cellForRow(at: indexPath) as! FriendTableViewCell
            publicUserProfileViewController.userId = selectedCell.uniqueId
        }
    }
}
