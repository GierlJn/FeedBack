
import Foundation
import UIKit
import SDWebImage
import Firebase

extension UIImageView{
    func setUserImage(userId: String) {
        let storageReference = Storage.storage().reference()
        let profileImageRef = storageReference.child(usersPath).child(userId).child("\(userId)-profileImage.jpg")
        let placeholderImage = UIImage(named: "user.png")
        self.sd_setImage(with: profileImageRef, placeholderImage: placeholderImage)
        self.setRounded()
    }
    
    func setRounded(){
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}
