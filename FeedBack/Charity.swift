

import Foundation
import Firebase

enum CharityCategory: String{
    case animals = "animals"
    case health = "health"
    case enviromental = "enviromental"
    case others = "others"
}

enum CharityImpactType: String{
    case childTreated = "treatchild"
    case netFounded = "malarianets"
    case ntdTreated = "treatntd"
    case none = "none"
}


class Charity: NSObject{
    var cid: String
    var name: String
    var category: CharityCategory
    var impactPerDollar: Float
    var impactType: CharityImpactType
    var website: String
    
    init(cid: String, name: String, impactCount: Float, impactType: CharityImpactType, website: String, category: CharityCategory){
        self.cid = cid
        self.name = name
        self.impactPerDollar = impactCount
        self.impactType = impactType
        self.website = website
        self.category = category
    }
    
    init?(snapshot: DataSnapshot){
        let cid = snapshot.key
        guard let charityDb = snapshot.value as? [String:Any] else { return nil }
        guard let name = charityDb[charityNameChildPath] as? String else { return nil }
        guard let categoryAsString = charityDb[charityCategoryChildPath] as? String else { return nil }
        guard let impactPerDollar = charityDb[charityImpactPerDollarChildPath] as? String else { return nil }
        guard let impactTypeAsString = charityDb[charityImpactTypeChildPath] as? String else { return nil }
        guard let website = charityDb[charityWebsiteChildPath] as? String else { return nil }
        
        
        self.cid = cid
        self.name = name
        self.category = CharityCategory.init(rawValue: categoryAsString) ?? CharityCategory.others
        self.impactPerDollar = Float(impactPerDollar)!
        self.impactType = CharityImpactType.init(rawValue: impactTypeAsString) ?? CharityImpactType.none
        self.website = website
        
    }
    
}
