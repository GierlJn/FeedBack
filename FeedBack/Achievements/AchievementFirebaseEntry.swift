
import Foundation
import Firebase

class AchievementFirebaseEntry: NSObject{
    var id: String
    var date: Double
    
    init(id: String, date: Double){
        self.id = id
        self.date = date
    }
    
    init?(snapshot: DataSnapshot){
        self.id = snapshot.key
        self.date = snapshot.value as! Double
    }
    
    func getTimeStampAsString() -> String {
        let x = self.date
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date as Date)
    }
}

