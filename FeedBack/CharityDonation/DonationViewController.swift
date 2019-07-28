import UIKit
import Firebase
import Stripe

let currency = "$"

class DonationViewController: UIViewController, UITextFieldDelegate{

    #warning("TODO: Refactor donationVc")
    
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
    var userAchievements = [AchievementFirebase]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUser = Auth.auth().currentUser
        ref = Database.database().reference()
        ref.child("users").child(currentUser!.uid).observe(DataEventType.value) { (snapshot) in
            guard let dbUser = User(snapshot: snapshot) else { return }
            self.user = dbUser
            self.userAchievements = dbUser.achievementHolder.achievements
            let userLevel = dbUser.donationHolder.getSumOfAllLevels()
            self.ref.child("users").child(self.currentUser!.uid).updateChildValues(([levelPath:userLevel] as [String:Any]))
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
    
    func initializeGameViewController() {
        let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"mainTabBarController") as! MainTabBarViewController
        mainTabBarController.selectedIndex = 2
        self.present(mainTabBarController, animated: true, completion: nil)
    }
}
