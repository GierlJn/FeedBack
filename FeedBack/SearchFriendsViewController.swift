
import UIKit
import Firebase
import FirebaseUI

class SearchFriendsViewController: UIViewController, UITableViewDelegate, AddFriendCellDelegate{


    @IBOutlet weak var textFieldOutlet: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    
    var searchInput = ""
    
    var userIdsForIndexPath = [Int:String]()
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: usersPath)
        tableView.delegate = self
    }
    
    @IBAction func abortButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func returnButtonPressed(_ sender: Any) {
        searchInput = textFieldOutlet.text!
        reloadDataSource()
        self.tableView.reloadData()
    }
    
    func reloadDataSource(){
        dataSource = FUITableViewDataSource(query: getQuery(), populateCell: { (tableView, indexPath, snapshot) -> UITableViewCell in
            let cell = Bundle.main.loadNibNamed("AddFriendsTableViewCell", owner: self, options: nil)?.first as! AddFriendsTableViewCell
            cell.delegate = self
            guard let user = User(snapshot: snapshot) else { return cell }
            let storageReference = Storage.storage().reference()
            let profileImageRef = storageReference.child(usersPath).child(user.uniqueId).child("\(user.uniqueId)-profileImage.jpg")
            let placeholderImage = UIImage(named: "user.png")
            cell.userImage.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
            cell.userNameLabel.text = user.userName
            cell.uniqueUserId = user.uniqueId
            return cell
        })
        dataSource?.bind(to: tableView)
    }
    
    func addFriendButtonPressedForUser(cell: AddFriendsTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        print("Button tapped on row \(indexPath.row)")
        let cell = tableView.cellForRow(at: indexPath) as! AddFriendsTableViewCell
        print(cell.uniqueUserId)
    }
    
    func addFriend(_ uniqueId: String){
        guard let currentUser = Auth.auth().currentUser else { return }
        self.ref.child(usersPath).child(currentUser.uid).child("friends")
    }
    
    func getQuery() -> DatabaseQuery {
        print(searchInput)
        return self.ref.queryOrdered(byChild: userNamePath).queryStarting(atValue: searchInput)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getQuery().removeAllObservers()
    }

}
