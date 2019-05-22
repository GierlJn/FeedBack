import Foundation
import Firebase

class FriendsHolder: NSObject{
    var friends = [Friend]()
    
    init(friends: [Friend]){
        self.friends = friends
    }
    
    init?(snapshot: DataSnapshot){
        for case let friendsnapshot as DataSnapshot in snapshot.children{
            guard let friend = Friend(snapshot: friendsnapshot) else {
                print(" friends not found ")
                return }
            self.friends.append(friend)
        }
    }
}
