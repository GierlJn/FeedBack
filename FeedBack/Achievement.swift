import UIKit
import Foundation

class Achievement{
    var key: String
    var name: String
    var description: String
    var image: UIImage
    
    init(key: String, name: String, description: String, image: UIImage){
        self.key = key
        self.name = name
        self.description = description
        self.image = image
    }
}



class Achievements{
    
    static let firstDonationAchievement = Achievement(key: "firstdonation", name: "Thank you", description: "Thank you for your first donation!", image: UIImage(imageLiteralResourceName: "firstDonationAchievement.png"))
    
    static let saveFiftyAchievement = Achievement(key: "fiftychildrentreated", name: "50 Children treated", description: "Wow! Your donations helped treating over 50 Children!", image: UIImage(imageLiteralResourceName: "saveFiftyAchievement.png"))
    
    static let saveHundredAchievement = Achievement(key: "hundredchildrentreated", name: "100 Children treated", description: "Awesome! Your donations helped treating over 100 Children!", image: UIImage(imageLiteralResourceName: "saveHundredAchievement.png"))
    
     static let pushNotificationAchievement = Achievement(key: "pushnotificationactivated", name: "Good Informed", description: "You are receiving push notifications from us!", image: UIImage(imageLiteralResourceName: "pushNotificiationAchievement.png"))
    
    static let shareAchievement = Achievement(key: "sharedstats", name: "Sharing is fun", description: "You spread the message in Social Media!", image: UIImage(imageLiteralResourceName: "share.png"))
    
    static let donateOneHundredAchievement = Achievement(key: "donateonehundred", name: "Good deeds", description: "Wow, you donated 100(/currency) to charities! Time to be proud of you!", image: UIImage(imageLiteralResourceName: "donateOneHundred.png"))
    

    static func getAllAvailableAchievements()->[Achievement]{
        var achievements = [Achievement]()
        achievements.append(firstDonationAchievement)
        achievements.append(saveFiftyAchievement)
        achievements.append(saveHundredAchievement)
        achievements.append(pushNotificationAchievement)
        achievements.append(shareAchievement)
        achievements.append(donateOneHundredAchievement)
        return achievements
    }
}
