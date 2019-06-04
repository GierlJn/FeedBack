

import Foundation
import UIKit
import Firebase

class User: NSObject{
    var uniqueId: String
    var userName: String
    var level: Int
    var friendsHolder: FriendsHolder
    var donationHolder: DonationsHolder
    var achievements: [Achievement]
    
    init(uniqueId: String, userName: String, level: Int, friendsHolder: FriendsHolder, donationHolder: DonationsHolder, achievements: [Achievement]){
        self.uniqueId = uniqueId
        self.userName = userName
        self.level = level
        self.friendsHolder = friendsHolder
        self.donationHolder = donationHolder
        self.achievements = achievements
    }
    
    init?(snapshot: DataSnapshot){
        self.uniqueId = snapshot.key
        guard let user = snapshot.value as? [String:Any] else {
            print(" user not found snapshot : \(snapshot.value)")
            return nil }
        guard let userName = user[userNamePath] as? String else {
            print(" userName not found ")
            return nil}
        guard let level = user[levelPath] as? Int else {
            print(" level not found ")
            return nil}
        guard let donationHolder = DonationsHolder(snapshot: snapshot.childSnapshot(forPath: "donations")) else {
            print(" donationholder not found " )
            return nil }
        guard let friendHolder = FriendsHolder(snapshot: snapshot.childSnapshot(forPath: "friends")) else {
            print(" friendHolder not found " )
            return nil }

        self.userName = userName
        self.level = level
        self.friendsHolder = friendHolder
        self.achievements = [Achievement]()
        self.donationHolder = donationHolder
    }
    
    
    
    func getUserImage(completion: @escaping(UIImage)->()){
        let storageReference = Storage.storage().reference()
        let profileImageRef = storageReference.child("users").child(uniqueId).child("\(uniqueId)-profileImage.jpg")
        profileImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // no image found
                let defaultImage = UIImage(imageLiteralResourceName: "user")
                completion(defaultImage)
            } else {
                let image = UIImage(data: data!)
                completion(image!)
            }
        }
    }
}

