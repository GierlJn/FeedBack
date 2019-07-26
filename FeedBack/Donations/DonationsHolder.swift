import Foundation
import Firebase

class DonationsHolder: NSObject{
    var donations = [Donation]()
    
    init(donations: [Donation]){
        self.donations = donations
    }
    
    init?(snapshot: DataSnapshot){
        for case let donationSnapshot as DataSnapshot in snapshot.children{
            guard let donation = Donation(snapshot: donationSnapshot) else {
                print(" donations not found ")
                return }
            self.donations.append(donation)
        }
    }
    
    func getMappedDonations()->[Donation]{
        var mappedDonations = [Donation]()
        for impactType in CharityImpactType.allValues{
            let donationsForImpactType = donations.filter{
                return $0.impactType == impactType }
            let sum: Float = donationsForImpactType.reduce(0.0) { (result: Float, donation: Donation) -> Float in
                return result + Float(donation.impactAmount)!
            }
            if(!donationsForImpactType.isEmpty){
                let charityName: String = donationsForImpactType[0].name // MARK TODO: to be changed, when impacttypes can have more than one charity
                let charityLogo: String = donationsForImpactType[0].logo
                let mappedDonation = Donation(name: charityName, impactType: impactType, impactAmount: String(sum), logo: charityLogo, amount: 0, timeStamp: 0)
                mappedDonations.append(mappedDonation)
            }
        }
        return mappedDonations
    }
    
    func getTotalForImpactType(impactType: CharityImpactType)->Int{
        let mappedDonations = getMappedDonations()
        
        switch (impactType) {
        case .childTreated:
            let childrenDonations = mappedDonations.first { (donation) -> Bool in
                donation.impactType == .childTreated
            }
            if((childrenDonations) != nil){
                return Int(Float(childrenDonations!.impactAmount)!)
            }else{
                return 0
            }
            
        default:
            print("error getting total for impact type")
            return 0
        }
    }
    
    func getTotalDonationSum()->Float{
        let sum: Float = donations.reduce(0.0) { (result: Float, donation: Donation) -> Float in
            return result + donation.amount
        }
        return sum
    }
    
    func getSumOfAllLevels()->Int{
        let mappedDonations = getMappedDonations()
        let sum: Int = mappedDonations.reduce(0) { (result: Int, donation: Donation) -> Int in
            return result + donation.getLevelForImpactAmount()
        }
        return sum
    }
    
}
