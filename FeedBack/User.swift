

import Foundation
import UIKit
import Firebase

class User: NSObject{
    var userName: String
    var level: Int
    var friends: [Friend]
    var donations: [GameDonation]
    var achievements: [Achievement]
    var mappedDonations: [GameDonation]?
    
    init(userName: String, level: Int, friends: [Friend], donations: [GameDonation], achievements: [Achievement]){
        self.userName = userName
        self.level = level
        self.friends = friends
        self.donations = donations
        self.achievements = achievements
    }
    
    init?(snapshot: DataSnapshot){
        guard let user = snapshot.value as? [String:Any] else {
            print(" user not found snapshot : \(snapshot.value)")
            return nil }
        guard let userName = user[userNamePath] as? String else {
            print(" userName not found ")
            return nil}
        guard let level = user[levelPath] as? Int else {
            print(" level not found ")
            return nil}
        self.userName = userName
        self.level = level
        self.donations = [GameDonation]()
        self.friends = [Friend]()
        self.achievements = [Achievement]()
        
        let friendSnapshot = snapshot.childSnapshot(forPath: "friends")
        for case let friendSnapshot as DataSnapshot in friendSnapshot.children{
            guard let friend = Friend(snapshot: friendSnapshot) else {
                print(" friends not found ")
                return }
            self.friends.append(friend)
        }
        
        let donationSnapshot = snapshot.childSnapshot(forPath: "donations")
        for case let donationSnapshot as DataSnapshot in donationSnapshot.children{
            guard let donation = GameDonation(snapshot: donationSnapshot) else {
                print(" donations not found ")
                return }
            self.donations.append(donation)
        }
    }
    
    func mapDonations(){
        self.mappedDonations = [GameDonation]()
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
                mappedDonations!.append(mappedDonation)
            }
        }
    }
    
    func getTotalDonationSum()->Float{
        let sum: Float = donations.reduce(0.0) { (result: Float, donation: GameDonation) -> Float in
            return result + donation.amount
        }
        return sum
    }
    
    func getSumOfAllLevels()->Int{
        let sum: Int = donations.reduce(0) { (result: Int, donation: GameDonation) -> Int in
            return result + donation.getLevelForImpactAmount()
        }//nicht auf jede einzelen donation sondern auf zusammengeasste mapdonation
        return sum
    }
    
    
    
}

