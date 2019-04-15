

import Foundation
import UIKit

class UserDataModel{
    
    static let sampleData:Dictionary<String, Any> = [
        "picture": #imageLiteral(resourceName: "arya_stark"),
        "name" : "Arya Stark",
        "points" : "666",
        "achievements" : [AchievementModel(image: UIImage(imageLiteralResourceName: "lion.png"), title: "First Blood"), AchievementModel(image: UIImage(imageLiteralResourceName: "lion.png"), title: "No One")],
    ]
    
    
}
