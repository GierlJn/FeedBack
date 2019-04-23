

import Foundation
import UIKit

struct User{
    let userName: String
    let userLevel: Int
    var userAvatar: UIImage?
    
    mutating func setUserAvatar(avatar: UIImage){
        self.userAvatar = avatar
    }
}
