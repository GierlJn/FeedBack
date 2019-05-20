import Foundation
import Firebase

class GameDonation: NSObject{
    var name: String
    var impactType: CharityImpactType
    var impactAmount: Int
    
    init(name: String, impactType: CharityImpactType, impactAmount: Int){
        self.name = name
        self.impactType = impactType
        self.impactAmount = impactAmount
    }
    
    init?(snapshot: DataSnapshot){
        guard let donationDb = snapshot.value as? [String:Any] else { return nil }
        guard let name = donationDb[charityNameChildPath] as? String else { return nil }
        guard let impactTypeAsString = donationDb[impactTypeChildPath] as? String else { return nil }
        guard let impactAmount = donationDb[impactAmountChildPath] as? Int else { return nil }
        
        self.name = name
        self.impactType = CharityImpactType.init(rawValue: impactTypeAsString) ?? CharityImpactType.none
        self.impactAmount = impactAmount
    }
}


