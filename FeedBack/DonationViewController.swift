import UIKit

class DonationViewController: UIViewController, UITextFieldDelegate{

    var charity: Charity?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userInputAmountTextField: UITextField!
    @IBOutlet weak var calculatedCharityImpactTextLabel: UILabel!
    @IBOutlet weak var impactView: UIView!
    var impactPerDollar: Float?
    @IBOutlet weak var impactDescriptionTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInputAmountTextField.delegate = self
        userInputAmountTextField.keyboardType = .numberPad
        userInputAmountTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                            for: UIControl.Event.editingChanged)
        if(charity != nil){
            titleLabel.text = charity!.name
            impactPerDollar = charity?.impactPerDollar
            impactDescriptionTextLabel.text = createImpactDisplayText(impactType: charity!.impactType)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
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
    
    func createImpactDisplayText(impactType: CharityImpactType)->String{
        switch(impactType){
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
        
        
        
    }
}
