import Foundation
import FirebaseDatabase

class AchievementsHolder: NSObject{
    var achievements = [Achievement]()
    
    init(achievements: [Achievement]){
        self.achievements = achievements
    }
    
    init?(snapshot: DataSnapshot){
        for case let achievementSnap as DataSnapshot in snapshot.children{
            guard let achievement = Achievement(snapshot: achievementSnap) else {
                print(" achievement not found ")
                return }
            self.achievements.append(achievement)
        }
    }
}
