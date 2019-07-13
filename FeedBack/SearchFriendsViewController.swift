
import UIKit
import Firebase
import FirebaseUI

class SearchFriendsViewController: UIViewController, UITableViewDelegate, AddFriendCellDelegate, UITextFieldDelegate, UserManagerDelegate{
    
    @IBOutlet weak var textFieldOutlet: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var ref: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    var currentUser = Auth.auth().currentUser
    var searchInput = ""
    var currentUserData: User?
    let userManager = UserManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if(currentUser == nil){return}
        userManager.observeUserData(forUser: currentUser!.uid)
        userManager.delegate = self
        ref = Database.database().reference(withPath: usersPath)
        textFieldOutlet.returnKeyType = .search
        tableView.delegate = self
    }
    
    func userDataUpdated(user: User) {
        self.currentUserData = user
        reloadDataSource()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getQuery().removeAllObservers()
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
            cell.config(with: user)
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
        if(currentUserData?.friendsHolder.friends.contains(where: { (friend) -> Bool in
            friend.uniqueId == uniqueId
        }) ?? false){
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AddFriendsTableViewCell
        guard cell.uniqueUserId != nil else { return }
        performSegue(withIdentifier: "goToPublicProfile", sender: indexPath)
    }
    
    func addFriendButtonPressedForUser(cell: AddFriendsTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let cell = tableView.cellForRow(at: indexPath) as! AddFriendsTableViewCell
        guard let friendId = cell.uniqueUserId else { return }
        addFriend(friendId)
        self.tableView.reloadData()
        reloadDataSource()
    }
    
    func addFriend(_ uniqueId: String){
        guard let currentUser = Auth.auth().currentUser else { return }
        let updateValues = [uniqueId:"true"] as [String:Any]
        self.ref.child(currentUser.uid).child("friends").updateChildValues(updateValues)
    }
    
    func getQuery() -> DatabaseQuery {
        return self.ref.queryOrdered(byChild: userNamePath).queryStarting(atValue: searchInput)
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
