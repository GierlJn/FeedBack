import Foundation
import Firebase

class GameDonation: NSObject{
    var name: String
    var impactType: CharityImpactType
    var impactAmount: String
    
    init(name: String, impactType: CharityImpactType, impactAmount: String){
        self.name = name
        self.impactType = impactType
        self.impactAmount = impactAmount
    }
    
    init?(snapshot: DataSnapshot){
        guard let donationDb = snapshot.value as? [String:Any] else {
            print("donation not found")
            return nil }
        guard let name = donationDb[charityNameChildPath] as? String else {
            print("charityName not found")
            return nil }
        guard let impactTypeAsString = donationDb[impactTypeChildPath] as? String else {
            print("impactTypeAsString not found")
            return nil }
        guard let impactAmount = donationDb[impactAmountChildPath] as? String else {
            print("impactAmount not found")
            return nil }
        
        self.name = name
        self.impactType = CharityImpactType.init(rawValue: impactTypeAsString) ?? CharityImpactType.none
        self.impactAmount = impactAmount
    }
}


