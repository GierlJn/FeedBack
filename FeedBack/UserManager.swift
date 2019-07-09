
import Foundation
import Firebase
import FirebaseUI

protocol UserManagerDelegate: class {
    func userDataUpdated(user: User)
}

class UserManager{
    
    var ref: DatabaseReference!
    var allRegisteredUsers = [User]()
    var user: User?
    weak var delegate: UserManagerDelegate?
    
    
    init(){
        ref = Database.database().reference(withPath: usersPath)
    }
    
    func observeUserData(forUser id: String){
        let userRef = Database.database().reference(withPath: "users").child(id)
        userRef.observe(DataEventType.value) { (snapshot) in
            guard let user = User(snapshot: snapshot) else { return }
            self.user = user
            self.delegate?.userDataUpdated(user: user)
        }
    }
    
    
    
    func isUserRegistered(with id: String, completion: @escaping (_ exists: Bool, _ user: User?) -> ()) {
        ref.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                // user is already in the database
                completion(true, User(snapshot: snapshot))
            } else {
                // new user
                completion(false, nil)
            }
        }
    }
    
    func createInitialUserInfo(withUsername username: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("no current user")
            return }
        let changeRequest = currentUser.createProfileChangeRequest()
        changeRequest.displayName = username
        changeRequest.commitChanges() { (error) in
            if error != nil {
                print("error creating user")
                return
            }
            
            let initialValues = [userNamePath: username,
                                 levelPath:1] as [String: Any]
            self.ref.child(currentUser.uid).updateChildValues(initialValues)
            print("user is created in db")
            UserDefaults.standard.set(false, forKey: "pushNotificationKey")
            
        }
        
    }
    
}
