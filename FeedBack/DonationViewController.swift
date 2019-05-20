import UIKit
import Firebase

class DonationViewController: UIViewController, UITextFieldDelegate{

    var charity: Charity?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userInputAmountTextField: UITextField!
    @IBOutlet weak var calculatedCharityImpactTextLabel: UILabel!
    @IBOutlet weak var impactView: UIView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var impactDescriptionTextLabel: UILabel!
    var impactPerDollar: Float?
    var charityId: String?
    var impactType: CharityImpactType?
    var ref: DatabaseReference!
    var user: Firebase.User?
    let currency = "$"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        user = Auth.auth().currentUser
        
        userInputAmountTextField.delegate = self
        userInputAmountTextField.keyboardType = .numberPad
        userInputAmountTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                            for: UIControl.Event.editingChanged)
        guard let charity = charity else { return }
        titleLabel.text = charity.name
        impactPerDollar = charity.impactPerDollar
        charityId = charity.cid
        impactType = charity.impactType
        impactDescriptionTextLabel.text = createImpactDisplayText()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        if(string.rangeOfCharacter(from: invalidCharacters) == nil){
            return true
        }
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
    
    func createImpactDisplayText()->String{
        switch(impactType!){
        case .childTreated:
            return "children treated"
        case .netFounded:
            return "funded malaria nets"
        case .ntdTreated:
            return "treated people"
        case .none:
            return ""
        }
    }
    @IBAction func donateButtonPressed(_ sender: Any) {
        guard let user = user else { return }
        guard let donationAmount = userInputAmountTextField.text else { return }
        guard let impactType = impactType?.rawValue else { return }
        guard let charityId = charityId else { return }
        
        let timestamp = NSDate().timeIntervalSince1970
        if(Int(donationAmount)! < 1){
            showMessagePrompt("Donation must be atleast 1\(currency)")
            return
        }
        let updateValues = ["charityid":charityId,
                            "donationamount":donationAmount,
                            "impacttype":impactType,
                            "timestamp":timestamp,
                            "currency":currency] as [String: Any]
        self.ref.child("users").child(user.uid).child("donations").childByAutoId().updateChildValues(updateValues)
    
        let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"mainTabBarController") as! MainTabBarViewController
        mainTabBarController.selectedIndex = 3
        self.present(mainTabBarController, animated: true, completion: nil)
    }
}
