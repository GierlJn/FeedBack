

import Foundation
import Firebase

enum CharityCategory: String{
    case animals = "Animals"
    case health = "Health"
    case enviromental = "Enviromental"
    case others = "Others"
}

enum CharityImpactType{
    case childTreated, netFounded, ntdTreated, none
}


class Charity: NSObject{
    var cid: String
    var name: String
    var category: CharityCategory
    var impactCount: Int
    var impactType: CharityImpactType
    var website: String
    
    init(cid: String, name: String, impactCount: Int, impactType: CharityImpactType, website: String, category: CharityCategory){
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
        guard let name = charityDb["charityname"] as? String else { return nil }
        guard let categoryAsString = charityDb["category"] as? String else { return nil }
        guard let impactCount = charityDb["impactcount"] as? String else { return nil }
        guard let impactTypeAsString = charityDb["impacttype"] as? String else { return nil }
        guard let website = charityDb["website"] as? String else { return nil }
        
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
        self.impactCount = Int(impactCount)!
        self.impactType = getType(impactTypeAsString)
        self.website = website
        
    }
    
}
