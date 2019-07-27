import Foundation
import FirebaseDatabase

class AchievementFirebaseHolder: NSObject{
    var achievements = [AchievementFirebase]()
    
    init(achievements: [AchievementFirebase]){
        self.achievements = achievements
    }
    
    init?(snapshot: DataSnapshot){
        for case let achievementSnap as DataSnapshot in snapshot.children{
            guard let achievement = AchievementFirebase(snapshot: achievementSnap) else {
                print(" achievement not found ")
                return }
            self.achievements.append(achievement)
        }
    }
}
