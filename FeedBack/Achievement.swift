import UIKit
import Foundation

class Achievement{
    var key: String
    var name: String
    var messageWhenAchieved: String
    var description: String
    var image: UIImage
    
    init(key: String, name: String, messageWhenAchieved: String, image: UIImage, description: String){
        self.key = key
        self.name = name
        self.messageWhenAchieved = messageWhenAchieved
        self.image = image
        self.description = description
    }
}



class Achievements{
    
    static let firstDonationAchievement = Achievement(key: "firstdonation", name: "Thank you", messageWhenAchieved: "Thank you for your first donation!", image: UIImage(imageLiteralResourceName: "firstDonationAchievement.png"), description: "Do your first donation with this app.")
    
    static let saveFiftyAchievement = Achievement(key: "fiftychildrentreated", name: "50 Children treated", messageWhenAchieved: "Wow! Your donations helped treating over 50 children!", image: UIImage(imageLiteralResourceName: "saveFiftyAchievement.png"), description: "Help treating 50 children with your donations")
    
    static let saveHundredAchievement = Achievement(key: "hundredchildrentreated", name: "100 Children treated", messageWhenAchieved: "Awesome! Your donations helped treating over 100 children!", image: UIImage(imageLiteralResourceName: "saveHundredAchievement.png"), description: "Help treating 50 children with your donations")
    
    static let pushNotificationAchievement = Achievement(key: "pushnotificationactivated", name: "Good Informed", messageWhenAchieved: "You are receiving push notifications from us!", image: UIImage(imageLiteralResourceName: "pushNotificiationAchievement.png"), description: "Turn on push notifications in settings to get reminders.")
    
    static let shareAchievement = Achievement(key: "sharedstats", name: "Sharing is fun", messageWhenAchieved: "You spread the message in Social Media!", image: UIImage(imageLiteralResourceName: "share.png"), description: "Share the impact that your donations make in Social Media")
    
    static let donateOneHundredAchievement = Achievement(key: "donateonehundred", name: "Good deeds", messageWhenAchieved: "Wow, you donated 100\(currency) to charities! Time to be proud of you!", image: UIImage(imageLiteralResourceName: "donateOneHundred.png"), description: "Donate 100\(currency) with this app")
    

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
