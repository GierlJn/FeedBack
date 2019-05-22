import Foundation
import Firebase

class DonationsHolder: NSObject{
    var donations = [GameDonation]()
    
    init(donations: [GameDonation]){
        self.donations = donations
    }
    
    init?(snapshot: DataSnapshot){
        for case let donationSnapshot as DataSnapshot in snapshot.children{
            guard let donation = GameDonation(snapshot: donationSnapshot) else {
                print(" donations not found ")
                return }
            self.donations.append(donation)
        }
    }
    
    func getMappedDonations()->[GameDonation]{
        var mappedDonations = [GameDonation]()
        for impactType in CharityImpactType.allValues{
            let donationsForImpactType = donations.filter{
                return $0.impactType == impactType }
            let sum: Float = donationsForImpactType.reduce(0.0) { (result: Float, donation: GameDonation) -> Float in
                return result + Float(donation.impactAmount)!
            }
            if(!donationsForImpactType.isEmpty){
                let charityName: String = donationsForImpactType[0].name // to be changed, impacttypes can have different charities
                let charityLogo: String = donationsForImpactType[0].logo
                let mappedDonation = GameDonation(name: charityName, impactType: impactType, impactAmount: String(sum), logo: charityLogo, amount: 0)
                mappedDonations.append(mappedDonation)
            }
        }
        return mappedDonations
    }
    
    func getTotalDonationSum()->Float{
        let sum: Float = donations.reduce(0.0) { (result: Float, donation: GameDonation) -> Float in
            return result + donation.amount
        }
        return sum
    }
    
    func getSumOfAllLevels()->Int{
        let mappedDonations = getMappedDonations()
        let sum: Int = mappedDonations.reduce(0) { (result: Int, donation: GameDonation) -> Int in
            return result + donation.getLevelForImpactAmount()
        }//nicht auf jede einzelen donation sondern auf zusammengeasste mapdonation
        return sum
    }
    
}
