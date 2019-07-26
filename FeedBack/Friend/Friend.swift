

import Foundation
import Firebase

class Friend: NSObject{
    var uniqueId: String
    
    init(uniqueId: String){
        self.uniqueId = uniqueId
    }
    
    init?(snapshot: DataSnapshot){
        self.uniqueId = snapshot.key
    }
    
}
