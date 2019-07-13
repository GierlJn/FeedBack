
import UIKit
import Firebase
import FirebaseUI


class ProfileViewController: UIViewController, UserManagerDelegate{
 
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
    var achievementCollectionViewProvider = AchievementCollectionViewProvider()
    var impactTableViewProvider = ImpactTableViewProvider()
    var friendsTableViewProvider = FriendTableViewProvider()
    var donationHistoryTableViewProvider = DonationsHistoryTableViewProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = Auth.auth().currentUser else { return }
        let userManager = UserManager()
        userManager.delegate = self
        userManager.observeUserData(forUser: currentUser.uid)
        userImage.setUserImage(userId: currentUser.uid)
        setupCollectionView()
        setupImpactTableView()
        setupFriendsTableView()
        setupDonationTableView()
    }
    
    internal func userDataUpdated(user: User) {
        self.user = user
        self.achievementCollectionViewProvider.userDataUpdated(achievements: user.achievementHolder.achievements)
        self.impactTableViewProvider.updateDonations(mappedDonations: user.donationHolder.getMappedDonations())
        self.friendsTableViewProvider.update(friends: user.friendsHolder.friends)
        self.donationHistoryTableViewProvider.update(donations: user.donationHolder.donations)
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
    
    fileprivate func setupCollectionView() {
        achievementCollectionView.dataSource = achievementCollectionViewProvider
        achievementCollectionView.delegate = achievementCollectionViewProvider
        achievementCollectionView.register(UINib.init(nibName: "AchievementCell", bundle: nil), forCellWithReuseIdentifier: "achievementCell")
    }
    
    fileprivate func setupImpactTableView() {
        impactTableView.dataSource = impactTableViewProvider
        impactTableView.delegate = impactTableViewProvider
        impactTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    fileprivate func setupDonationTableView() {
        donationTableView.dataSource = donationHistoryTableViewProvider
        impactTableView.delegate = donationHistoryTableViewProvider
    }
    
    fileprivate func setupFriendsTableView(){
        friendsTableView.dataSource = friendsTableViewProvider
        friendsTableView.delegate = friendsTableViewProvider
        
    }
    
    @IBAction func settingsButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "showSettingsSegue", sender: self)
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
