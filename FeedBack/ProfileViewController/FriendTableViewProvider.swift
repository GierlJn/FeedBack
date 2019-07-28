#warning("TODO: Refactor Providers")
//import UIKit
//import Foundation
//import Firebase
//
//class FriendTableViewProvider: NSObject, UITableViewDataSource, UITableViewDelegate{
//
//    private var friends = [Friend]()
//
//    internal func update(friends: [Friend]) {
//        self.friends = friends
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return friends.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = Bundle.main.loadNibNamed("FriendTableViewCell", owner: self, options: nil)?.first as! FriendTableViewCell
//        let friend = friends[indexPath.row]
//        let friendRef = Database.database().reference(withPath: "users").child(friend.uniqueId)
//        friendRef.observe(DataEventType.value) { (snapshot) in
//            guard let friendUser = User(snapshot: snapshot) else { return }
//            cell.uniqueId = friend.uniqueId
//            cell.userNameLabel.text = friendUser.userName
//            cell.userLevelLabel.text = String(friendUser.level)
//            let storageReference = Storage.storage().reference()
//            let profileImageRef = storageReference.child(usersPath).child(friend.uniqueId).child("\(friend.uniqueId)-profileImage.jpg")
//            let placeholderImage = UIImage(named: "user.png")
//            cell.userImage.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
//            cell.userImage.setRounded()
//        }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //MARK TODO: check if its the right vc
//        UIApplication.topViewController()?.performSegue(withIdentifier: "goToPublicUserProfile", sender: indexPath)
//    }
//
//
//}
