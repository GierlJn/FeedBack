import UIKit
import Firebase
import Stripe

let currency = "$"

class DonationViewController: UIViewController, UITextFieldDelegate{

    var charity: Charity?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userInputAmountTextField: UITextField!
    @IBOutlet weak var calculatedCharityImpactTextLabel: UILabel!
    @IBOutlet weak var impactView: UIView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var impactDescriptionTextLabel: UILabel!
    var impactPerDollar: Float?
    var charityName: String?
    var impactType: CharityImpactType?
    var charityLogo: String?
    var ref: DatabaseReference!
    var donationSumRef: DatabaseReference!
    var currentUser: Firebase.User?
    var alertQueue = [UIAlertController]()
    var transaction: Transaction?
    let achievmentManager = AchievementManager()
    var user: User?
    var userAchievements = [AchievementFirebaseEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUser = Auth.auth().currentUser
        ref = Database.database().reference()
        ref.child("users").child(currentUser!.uid).observe(DataEventType.value) { (snapshot) in
            guard let dbUser = User(snapshot: snapshot) else { return }
            self.user = dbUser
            self.userAchievements = dbUser.achievementHolder.achievements
        }
        
        userInputAmountTextField.delegate = self
        userInputAmountTextField.keyboardType = .numberPad
        userInputAmountTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                            for: UIControl.Event.editingChanged)
        
        
        guard let charity = charity else { return }
        titleLabel.text = charity.name
        charityName = charity.name
        impactPerDollar = charity.impactPerDollar
        impactType = charity.impactType
        charityLogo = charity.logo
        impactDescriptionTextLabel.text = impactType?.getShortDescription()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        if(string.rangeOfCharacter(from: invalidCharacters) == nil){
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        print("should return ")
        return false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(userInputAmountTextField.text!.isEmpty){
            impactView.isHidden = true
        }else{
            impactView.isHidden = false
            updateImpactTextLabel()
        }
    }

    func updateImpactTextLabel(){
        calculatedCharityImpactTextLabel.text =  String(calculateImpactAmount(amountEntered: Float(userInputAmountTextField.text!)!, valuePerDollar: impactPerDollar!))
    }
    
    func calculateImpactAmount(amountEntered: Float, valuePerDollar: Float)->Float{
        if amountEntered == 0{ return 0}
        if valuePerDollar == 0{ return 0}
        return amountEntered*valuePerDollar
    }

    @IBAction func donateButtonPressed(_ sender: Any) {
        guard let donationAmount = userInputAmountTextField.text else { return }
        guard let charityName = charityName else { return }

        if(Int(donationAmount)! < 1){
            showMessagePrompt("Donation must be atleast 1\(currency)")
            return
        }
        transaction = Transaction(name: charityName, amount: Int(donationAmount)! * 100)
        
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        navigationController?.pushViewController(addCardViewController, animated: true)
    }
    
    fileprivate func processDonation(){
        guard let user = user else { return }
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
        
            let userLevel = user.donationHolder.getSumOfAllLevels()
            self.ref.child("users").child(currentUser!.uid).updateChildValues(([levelPath:userLevel] as [String:Any]))
        self.updateAchievements(donatedSum: Float(Int(donationAmount)!))
    }
    
    fileprivate func updateAchievements(donatedSum: Float) {
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

    fileprivate func initializeGameViewController() {
        let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"mainTabBarController") as! MainTabBarViewController
        mainTabBarController.selectedIndex = 2
        self.present(mainTabBarController, animated: true, completion: nil)
    }
}


extension DonationViewController: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        StripeClient.shared.completeCharge(with: token, amount: transaction!.amount, description: transaction!.name) { result in
            switch result {
            case .success:
                completion(nil)
                print("token.allResponseFields")
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
}
