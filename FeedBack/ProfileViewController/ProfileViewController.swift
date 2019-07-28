
import UIKit
import Firebase

class DynamicProfileViewController: UIViewController{
    #warning("TODO: Refactor ProfileVC")
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userLevel: UILabel!
    @IBOutlet weak var userRankLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var achievementCollectionView: UICollectionView!
    
    var user: User?
    let achievementCollectionViewProvider = AchievementCollectionViewProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupCollectionView()
        guard let currentUser = Auth.auth().currentUser else { return }
        let userManager = UserManager()
        userManager.delegate = self
        userManager.observeUserData(forUser: currentUser.uid)
    }
    
    fileprivate func configureTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.dataSource = self
        tableView.delegate = self
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
        self.userRankLabel.text = LevelManager.getRankForLevel(level: user.level)
        self.userAvatar.setUserImage(userId: user.uniqueId)
    }
    
    func addFriendsButtonPressed() {
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
    
    
}

extension DynamicProfileViewController: UITableViewDataSource{
    
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
            sectionName = NSLocalizedString("Your Impact summary", comment: "")
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        
        if(section == 2){
            let frame = tableView.frame
            let button = UIButton(frame: .zero)
            button.tag = section
            button.setTitle("Add friend", for: .normal)
            button.addTarget(self,action:#selector(buttonClicked),for:.touchUpInside)
            button.setTitleColor(UIColor(red: 0.749, green: 0.6784, blue: 0.9686, alpha: 1.0), for: UIControl.State.normal)
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            button.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(button)
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalTo: headerView.widthAnchor),
                button.heightAnchor.constraint(equalTo: headerView.heightAnchor),
                button.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                button.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                ])
            headerView.backgroundColor = UIColor.white
            return headerView
        }else if(section == 0 && user?.donationHolder.donations.count ?? 0 > 0){
            let frame = tableView.frame
            let button = UIButton(frame: .zero)
            button.tag = section
            button.setTitle("Share your good deeds", for: .normal)
            button.addTarget(self,action:#selector(shareButtonPressed),for:.touchUpInside)
            button.setTitleColor(UIColor(red: 0.749, green: 0.6784, blue: 0.9686, alpha: 1.0), for: UIControl.State.normal)
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            button.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(button)
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalTo: headerView.widthAnchor),
                button.heightAnchor.constraint(equalTo: headerView.heightAnchor),
                button.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                button.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                ])
            headerView.backgroundColor = UIColor.white
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 2){
            return CGFloat(40)
        }else if(section == 0 && user?.donationHolder.donations.count ?? 0 > 0){
            return CGFloat(40)
        }
        return 0
    }
    
    @objc func shareButtonPressed(sender: UIButton) {
        showShareActivityOptions(generateTextToShare())
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
    
    @objc func buttonClicked(sender: UIButton)
    {
        addFriendsButtonPressed()
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
            guard let publicUserProfileViewController = segue.destination as? PublicProfileViewController else{
                return
            }
            let selectedCell = tableView.cellForRow(at: indexPath) as! FriendTableViewCell
            publicUserProfileViewController.userId = selectedCell.uniqueId
        }
    }
}

extension DynamicProfileViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 2){
            UIApplication.topViewController()?.performSegue(withIdentifier: "goToPublicUserProfile", sender: indexPath)
        }
    }
}

extension DynamicProfileViewController: UserManagerDelegate{
    func userDataUpdated(user: User) {
        self.user = user
        configureUserInfo()
        achievementCollectionViewProvider.userDataUpdated(achievements: user.achievementHolder.achievements)
        tableView.reloadData()
        achievementCollectionView.reloadData()
    }
}
