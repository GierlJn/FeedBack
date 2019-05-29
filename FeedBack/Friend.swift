

import Foundation
import Firebase

class Friend: NSObject{
    var uniqueId: String
    
    init(uniqueId: String){
        self.uniqueId = uniqueId
    }
    
    init?(snapshot: DataSnapshot){
        self.uniqueId = snapshot.key
       // guard let friendDict = snapshot.value as? [String:Any] else { return nil }
        //guard let level = friendDict[levelPath] as? Int else { return nil }
        //self.userName = userName
        //self.level = level
    }
    
}
