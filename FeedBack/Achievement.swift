
import Foundation
import Firebase

class Achievement: NSObject{
    var name: String
    
    init(name: String){
        self.name = name
    }
    
    init?(snapshot: DataSnapshot){
        self.name = snapshot.key
    }
}

