import Stripe
import UIKit
import Firebase

extension DonationViewController: STPAddCardViewControllerDelegate {
    
    #warning("TODO: Move Achievement Logic to FireBase")
    #warning("Refactor redundant functions for donations")
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        StripeClient.shared.completeCharge(with: token, amount: transaction!.amount, description: transaction!.name) { result in
            switch result {
            case .success:
                completion(nil)
                print(token.allResponseFields)
                let alertController = UIAlertController(title: "Congrats", message: "Your payment was successful!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.processDonation()
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func processDonation(){
        //guard let user = user else { return }
        guard let donationAmount = userInputAmountTextField.text else { return }
        guard let impactType = impactType?.rawValue else { return }
        guard let charityName = charityName else { return }
        guard let impactAmount = calculatedCharityImpactTextLabel.text else { return }
        guard let charityLogo = charityLogo else { return }
        guard let impactPerDollar = impactPerDollar else { return }
        let timestamp = NSDate().timeIntervalSince1970
        if(Int(donationAmount)! < 1){
            showMessagePrompt("Donation must be atleast 1\(currency)")
            return
        }
        
        let updateValues = [namePath:charityName,
                            donationAmountPath:donationAmount,
                            impactTypeChildPath:impactType,
                            timestampPath:timestamp,
                            currencyPath:currency,
                            impactAmountPath:impactAmount,
                            logoPath:charityLogo,
                            impactPerDollarPath:impactPerDollar] as [String: Any]
        self.ref.child("users").child(currentUser!.uid).child("donations").childByAutoId().updateChildValues(updateValues)
        
        
        
        self.updateAchievements(donatedSum: Float(Int(donationAmount)!), impactAmount: Int(Float(impactAmount)!), impactType: CharityImpactType(rawValue: impactType)!)
    }
    
    func updateAchievements(donatedSum: Float, impactAmount: Int, impactType: CharityImpactType) {
        if(!userHasAchievement(achievementId: "firstdonation")){
            print("first achievement")
            grantAchievementWithAlert("firstdonation")
        }
        if(!userHasAchievement(achievementId: "donateonehundred")){
            if(user!.donationHolder.getTotalDonationSum()+donatedSum >= 100){
                print("one hundred achievement")
                grantAchievementWithAlert("donateonehundred")
            }
        }
        
        if(impactType == .childTreated){
            if(!userHasAchievement(achievementId: "fiftychildrentreated")){
                if(user!.donationHolder.getTotalForImpactType(impactType: .childTreated) + impactAmount >= 50){
                    print("fiftychildrentreated")
                    grantAchievementWithAlert("fiftychildrentreated")
                }
            }
            if(!userHasAchievement(achievementId: "hundredchildrentreated")){
                if(user!.donationHolder.getTotalForImpactType(impactType: .childTreated) + impactAmount >= 100){
                    print("hundredchildrentreated")
                    grantAchievementWithAlert("hundredchildrentreated")
                }
            }
        }
        
        
        if (self.alertQueue.isEmpty){
            initializeGameViewController()
        }else{
            self.present(self.alertQueue.first!, animated: true)
            alertQueue.removeFirst()
        }
    }
    
    func grantAchievementWithAlert(_ achievementKey: String){
        guard let achievement = achievmentManager.getAchievementWithKey(achievementKey) else { return }
        achievmentManager.grantAchievementForKey(achievementKey, userId: currentUser!.uid)
        
        
        let alert = UIAlertController(title: achievement.name, message: achievement.messageWhenAchieved, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Nice!", style: .default) { (action) in
            if (self.alertQueue.isEmpty){
                print(self.alertQueue)
                self.initializeGameViewController()
                
            }else{
                self.present(self.alertQueue.first!, animated: true)
                self.alertQueue.removeFirst()
                print(self.alertQueue)
            }
        }
        alert.addAction(okAction)
        alertQueue.append(alert)
    }
    
    func userHasAchievement(achievementId: String)->Bool{
        if(userAchievements.contains(where: { (entry) -> Bool in
            entry.id == achievementId
        })){
            return true
        }else{
            return false
        }
    }
}

