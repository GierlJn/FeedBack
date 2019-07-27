
import Firebase
import UIKit

protocol AddFriendCellDelegate: class{
    func addFriendButtonPressedForUser(cell: AddFriendsTableViewCell)
}


class AddFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    var currentUser = Auth.auth().currentUser
    var uniqueUserId: String?
    
    weak var delegate: AddFriendCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    func config(with user: User){
        let storageReference = Storage.storage().reference()
        let profileImageRef = storageReference.child(usersPath).child(user.uniqueId).child("\(user.uniqueId)-profileImage.jpg")
        let placeholderImage = UIImage(named: "user.png")
        userImage.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
        userImage.setRounded()
        userNameLabel.text = user.userName
        uniqueUserId = user.uniqueId
    }
    
    func hideAddFriendButton(){
        addFriendButton.isHidden = true
    }

    @IBAction func addFriendButtonPressed(_ sender: Any) {
        self.delegate?.addFriendButtonPressedForUser(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


