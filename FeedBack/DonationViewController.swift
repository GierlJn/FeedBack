import UIKit

class DonationViewController: UIViewController, UITextFieldDelegate{

    var charity: Charity?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moneyAmountTextField: UITextField!
    @IBOutlet weak var impactAmountTextLabel: UILabel!
    @IBOutlet weak var impactView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moneyAmountTextField.delegate = self
        moneyAmountTextField.keyboardType = .numberPad
        
        if(charity != nil){
            titleLabel.text = charity!.name
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        impactView.isHidden = false
        
        let amountEntered = Float(textField.text!)
        let valuePerDollar = charity?.impactPerDollar
        
        impactAmountTextLabel.text =  String(amountEntered!*valuePerDollar!)
        
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
    
}
