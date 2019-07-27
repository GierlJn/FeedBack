
import UIKit
import Firebase
import FirebaseUI

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var userLevelLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    var uniqueId: String?
    
    static let identifier = "FriendTableViewCell"
    

    func configure(for friend: User){
        uniqueId = friend.uniqueId
        userNameLabel.text = friend.userName
        userLevelLabel.text = String(friend.level)
        let storageReference = Storage.storage().reference()
        let profileImageRef = storageReference.child(usersPath).child(friend.uniqueId).child("\(friend.uniqueId)-profileImage.jpg")
        let placeholderImage = UIImage(named: "user.png")
        userImage.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
        userImage.setRounded()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
