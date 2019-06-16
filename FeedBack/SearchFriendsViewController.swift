
import UIKit
import Firebase
import FirebaseUI

class SearchFriendsViewController: UIViewController, UITableViewDelegate, AddFriendCellDelegate, UITextFieldDelegate{


    @IBOutlet weak var textFieldOutlet: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    
    var currentUser = Auth.auth().currentUser
    var searchInput = ""
    
    var currentUserRef: DatabaseReference!
    var currentUserData: User?
    
    var friendsOfCurrentUser: [Friend]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldOutlet.returnKeyType = .search
        guard let currentUser = currentUser else { return }
        currentUserRef = Database.database().reference(withPath: "users").child(currentUser.uid)
        currentUserRef.observe(DataEventType.value) { (snapshot) in
            guard let currentUserData = User(snapshot: snapshot) else { return }
            self.currentUserData = currentUserData
            self.friendsOfCurrentUser = currentUserData.friendsHolder.friends
        }
        ref = Database.database().reference(withPath: usersPath)
        tableView.delegate = self
    }
    
    
    
    @IBAction func returnButtonPressed(_ sender: Any) {
        
        searchInput = textFieldOutlet.text!
        reloadDataSource()
        self.tableView.reloadData()
        self.view.endEditing(true)
    }
    
    func reloadDataSource(){
        dataSource = FUITableViewDataSource(query: getQuery(), populateCell: { (tableView, indexPath, snapshot) -> UITableViewCell in
            let cell = Bundle.main.loadNibNamed("AddFriendsTableViewCell", owner: self, options: nil)?.first as! AddFriendsTableViewCell
            guard let user = User(snapshot: snapshot) else { return cell }
            cell.delegate = self
            let storageReference = Storage.storage().reference()
            let profileImageRef = storageReference.child(usersPath).child(user.uniqueId).child("\(user.uniqueId)-profileImage.jpg")
            let placeholderImage = UIImage(named: "user.png")
            cell.userImage.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
            cell.userImage.setRounded()
            cell.userNameLabel.text = user.userName
            cell.uniqueUserId = user.uniqueId
            if(user.uniqueId == self.currentUser?.uid){
                cell.hideAddFriendButton()
            }
            if(self.userIsAddedAsFriend(uniqueId: user.uniqueId)){
                cell.hideAddFriendButton()
            }
            return cell
        })
        dataSource?.bind(to: tableView)
    }
    
    func userIsAddedAsFriend(uniqueId: String)->Bool{
        if(self.friendsOfCurrentUser!.contains(where: { (friend) -> Bool in
            friend.uniqueId == uniqueId
        })){
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AddFriendsTableViewCell
        guard let userId = cell.uniqueUserId else { return }
        performSegue(withIdentifier: "goToPublicProfile", sender: indexPath)
    }
    
    func addFriendButtonPressedForUser(cell: AddFriendsTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let cell = tableView.cellForRow(at: indexPath) as! AddFriendsTableViewCell
        guard let friendId = cell.uniqueUserId else { return }
        addFriend(friendId)
    }
    
    func addFriend(_ uniqueId: String){
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let updateValues = [uniqueId:"true"] as [String:Any]
        self.ref.child(currentUser.uid).child("friends").updateChildValues(updateValues)
        reloadDataSource()
        self.tableView.reloadData()
    }
    
    func getQuery() -> DatabaseQuery {
        print(searchInput)
        return self.ref.queryOrdered(byChild: userNamePath).queryStarting(atValue: searchInput)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getQuery().removeAllObservers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath: IndexPath = sender as? IndexPath else { return }
        guard let destinationVc: PublicUserProfileViewController = segue.destination as? PublicUserProfileViewController else{
            return
        }
        let cell = tableView.cellForRow(at: indexPath) as! AddFriendsTableViewCell
        guard let userId = cell.uniqueUserId else { return }
        destinationVc.userId = userId
    }

}
