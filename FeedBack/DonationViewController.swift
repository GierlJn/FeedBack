import UIKit
import Firebase

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
    var userRef: DatabaseReference!
    var donationSumRef: DatabaseReference!
    var user: Firebase.User?
    var alertQueue = [UIAlertController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        user = Auth.auth().currentUser
        
        userRef = Database.database().reference()
        donationSumRef = Database.database().reference()
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
        self.ref.child("users").child(user.uid).child("donations").childByAutoId().updateChildValues(updateValues)
        
        
        donationSumRef.child("users").child(user.uid).observe(DataEventType.value) { (snapshot) in
            guard let dbUser = User(snapshot: snapshot) else { return }
            let userLevel = dbUser.donationHolder.getSumOfAllLevels()
            let achievements = dbUser.achievementHolder.achievements
            self.userRef.child("users").child(user.uid).updateChildValues(([levelPath:userLevel] as [String:Any]))
            self.updateAchievements(achievements, dbUser)
        }
    }
    
    fileprivate func updateAchievements(_ achievements: [AchievementFirebaseEntry], _ dbUser: User) {
        if(!userHasAchievement(userAchievements: achievements, achievementId: "firstdonation")){
            print("first achievement")
            grantAchievementWithAlert(Achievements.firstDonationAchievement)
        }
        if(!userHasAchievement(userAchievements: achievements, achievementId: "donateonehundred")){
            if(dbUser.donationHolder.getTotalDonationSum() >= 100){
                print("one hundred achievement")
                grantAchievementWithAlert(Achievements.donateOneHundredAchievement)
            }
        }
        if (self.alertQueue.isEmpty){
            initializeGameViewController()
        }else{
            self.present(self.alertQueue.first!, animated: true)
            alertQueue.removeFirst()
        }
    }

    func grantAchievementWithAlert(_ achievement: Achievement){
        let timestamp = NSDate().timeIntervalSince1970
        guard let user = user else { return }
        self.userRef.child("users").child(user.uid).child("achievements").updateChildValues(([achievement.key:timestamp] as [String:Any]))
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
    
    func userHasAchievement(userAchievements: [AchievementFirebaseEntry], achievementId: String)->Bool{
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
