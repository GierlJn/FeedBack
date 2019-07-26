
import Foundation
import Firebase

class UserDataBase{
    var ref: DatabaseReference!
    
    init(){
        ref = Database.database().reference()
    }

}
