

import Foundation
import Firebase

enum CharityCategory: String{
    case animals = "animals"
    case health = "health"
    case enviromental = "enviromental"
    case others = "others"
}

enum CharityImpactType{
    case childTreated, netFounded, ntdTreated, none
}


class Charity: NSObject{
    var cid: String
    var name: String
    var category: CharityCategory
    var impactCount: Float
    var impactType: CharityImpactType
    var website: String
    
    init(cid: String, name: String, impactCount: Float, impactType: CharityImpactType, website: String, category: CharityCategory){
        self.cid = cid
        self.name = name
        self.impactCount = impactCount
        self.impactType = impactType
        self.website = website
        self.category = category
    }
    
    init?(snapshot: DataSnapshot){
        let cid = snapshot.key
        guard let charityDb = snapshot.value as? [String:Any] else { return nil }
        guard let name = charityDb[charityNameChildPath] as? String else { return nil }
        guard let categoryAsString = charityDb[charityCategoryChildPath] as? String else { return nil }
        guard let impactCount = charityDb[charityImpactPerDollarChildPath] as? String else { return nil }
        guard let impactTypeAsString = charityDb[charityImpactTypeChildPath] as? String else { return nil }
        guard let website = charityDb[charityWebsiteChildPath] as? String else { return nil }
        
        func getCategory(_ categoryString: String) -> CharityCategory{
            switch(categoryString){
            case "health":
                return CharityCategory.health
            case "enviroment":
                return CharityCategory.enviromental
            case "animals":
                return CharityCategory.animals
            default:
                return CharityCategory.others
            }
        }
        
        func getType(_ string: String) -> CharityImpactType{
            switch(string){
            case "childtreated":
                return CharityImpactType.childTreated
            case "netfounded":
                return CharityImpactType.netFounded
            case "ntdtreated":
                return CharityImpactType.ntdTreated
            default:
                return CharityImpactType.none
            }
        }
        
        self.cid = cid
        self.name = name
        self.category = getCategory(categoryAsString)
        self.impactCount = Float(impactCount)!
        self.impactType = getType(impactTypeAsString)
        self.website = website
        
    }
    
}
