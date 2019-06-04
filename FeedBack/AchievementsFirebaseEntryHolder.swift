import Foundation
import FirebaseDatabase

class AchievementsFirebaseEntryHolder: NSObject{
    var achievements = [AchievementFirebaseEntry]()
    
    init(achievements: [AchievementFirebaseEntry]){
        self.achievements = achievements
    }
    
    init?(snapshot: DataSnapshot){
        for case let achievementSnap as DataSnapshot in snapshot.children{
            guard let achievement = AchievementFirebaseEntry(snapshot: achievementSnap) else {
                print(" achievement not found ")
                return }
            self.achievements.append(achievement)
        }
    }
}
