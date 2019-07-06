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

