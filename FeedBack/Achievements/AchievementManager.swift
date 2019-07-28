import Foundation
import UIKit
import Firebase

#warning("TODO: Achievements to json file")

class AchievementManager{
    
    var availableAchievements = [Achievement]()
    let usersRef = Database.database().reference().child("users")
    
    init(){
        createAchievements()
    }
    
    func createAchievements(){
        availableAchievements.append(Achievement(key: "firstdonation", name: "Thank you", messageWhenAchieved: "Thank you for your first donation!", image: UIImage(imageLiteralResourceName: "firstDonationAchievement.png"), description: "Do your first donation with this app."))
        
        availableAchievements.append(Achievement(key: "fiftychildrentreated", name: "50 Children treated", messageWhenAchieved: "Wow! Your donations helped treating over 50 children!", image: UIImage(imageLiteralResourceName: "saveFiftyAchievement.png"), description: "Help treating 50 children with your donations"))
        
        availableAchievements.append(Achievement(key: "hundredchildrentreated", name: "100 Children treated", messageWhenAchieved: "Awesome! Your donations helped treating over 100 children!", image: UIImage(imageLiteralResourceName: "saveHundredAchievement.png"), description: "Help treating 100 children with your donations"))
        
        availableAchievements.append(Achievement(key: "pushnotificationactivated", name: "Good Informed", messageWhenAchieved: "You are receiving push notifications from us!", image: UIImage(imageLiteralResourceName: "pushNotificiationAchievement.png"), description: "Turn on push notifications in settings to get reminders."))
        
        availableAchievements.append(Achievement(key: "sharedstats", name: "Sharing is fun", messageWhenAchieved: "You spread the message in Social Media!", image: UIImage(imageLiteralResourceName: "share.png"), description: "Share the impact that your donations make in Social Media"))
        
        availableAchievements.append(Achievement(key: "donateonehundred", name: "Good deeds", messageWhenAchieved: "Wow, you donated 100\(currency) to charities! Time to be proud of you!", image: UIImage(imageLiteralResourceName: "donateOneHundred.png"), description: "Donate 100\(currency) with this app"))
    }
    
    func getAchievementWithKey(_ key: String)->Achievement?{
        return availableAchievements.first { (achievement) -> Bool in
            achievement.key == key
        }
    }
    
    func grantAchievementForKey(_ key: String, userId: String){
        let timestamp = NSDate().timeIntervalSince1970
        self.usersRef.child(userId).child("achievements").updateChildValues(([key:timestamp] as [String:Any]))
    }
}
