
import Foundation
import Firebase

class AchievementFirebaseEntry: NSObject{
    var id: String
    
    init(id: String){
        self.id = id
    }
    
    init?(snapshot: DataSnapshot){
        self.id = snapshot.key
    }
}

