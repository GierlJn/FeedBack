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
                let charityName: String = donationsForImpactType[0].name // to be changed, impacttypes can have different charities
                let charityLogo: String = donationsForImpactType[0].logo
                let mappedDonation = Donation(name: charityName, impactType: impactType, impactAmount: String(sum), logo: charityLogo, amount: 0, timeStamp: 0)
                mappedDonations.append(mappedDonation)
            }
        }
        return mappedDonations
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
