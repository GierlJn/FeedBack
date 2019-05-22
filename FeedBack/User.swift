

import Foundation
import UIKit
import Firebase

class User: NSObject{
    var userName: String
    var level: Int
    var friendsHolder: FriendsHolder
    var donationHolder: DonationsHolder
    var achievements: [Achievement]
    
    init(userName: String, level: Int, friendsHolder: FriendsHolder, donationHolder: DonationsHolder, achievements: [Achievement]){
        self.userName = userName
        self.level = level
        self.friendsHolder = friendsHolder
        self.donationHolder = donationHolder
        self.achievements = achievements
    }
    
    init?(snapshot: DataSnapshot){
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
}

