

import Foundation
import Firebase

class Friend: NSObject{
    var userName: String
    var level: Int
    
    init(userName: String, level: Int){
        self.userName = userName
        self.level = level
    }
    
    init?(snapshot: DataSnapshot){
        let userName = snapshot.key
        guard let friendDict = snapshot.value as? [String:Any] else { return nil }
        guard let level = friendDict[levelPath] as? Int else { return nil }
        self.userName = userName
        self.level = level
    }
    
}
