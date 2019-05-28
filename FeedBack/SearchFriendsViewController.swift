
import UIKit
import Firebase
import FirebaseUI

class SearchFriendsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var textFieldOutlet: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    
    var searchInput = ""
    
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
        self.tableView.reloadData()
    }
    
    func reloadDataSource(){
        dataSource = FUITableViewDataSource(query: getQuery(), populateCell: { (tableView, indexPath, snapshot) -> UITableViewCell in
            let cell = Bundle.main.loadNibNamed("AddFriendsTableViewCell", owner: self, options: nil)?.first as! AddFriendsTableViewCell
            guard let user = User(snapshot: snapshot) else { return cell }
            let storageReference = Storage.storage().reference()
            let profileImageRef = storageReference.child(usersPath).child(user.uniqueId).child("\(user.uniqueId)-profileImage.jpg")
            let placeholderImage = UIImage(named: "user.png")
            cell.userImage.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
            cell.userNameLabel.text = user.userName
            print(user)
            return cell
        })
        dataSource?.bind(to: tableView)
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
