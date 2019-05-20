import UIKit
import Firebase

class CharityInfoViewController: UIViewController {

    @IBOutlet weak var charityTitle: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    lazy var ref: DatabaseReference = Database.database().reference()
    
    var charityRef: DatabaseReference!
    var charityId = ""
    var charity: Charity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        charityRef = ref.child(charityChildPath).child(charityId)
        infoLabel.preferredMaxLayoutWidth = 500
        infoLabel.numberOfLines = 0
        
        infoLabel.layoutIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        charityRef.observe(DataEventType.value) { (snapshot) in
            self.charity = Charity(snapshot: snapshot)
            self.charityTitle.text = self.charity?.name
            self.infoLabel.text = "tetx tetx tetx tetx tetx tetx tetx tetx te tetx tetx tetx tetx tetx tetx  tetx tetx tetx tetx tetx tetx  tetx tetx tetx tetx tetx tetx  tetx tetx tetx tetx tetx tetx  tetx tetx tetx tetx tetx tetx  tetx tetx tetx tetx tetx tetx  tetx tetx tetx tetx tetx tetx  tetx tetx tetx tetx tetx tetx  tetx tetx tetx tetx tetx tetx  tetx tetx tetx tetx tetx tetx  tetx tetx tetx tetx tetx tetx  tetx tetx tetx tetx tetx tetx tx tetx tetx tetx tetx tetx tetx blablibub blablibub blablibub blablibub blablibub blablibub blablibub "
            self.infoLabel.sizeToFit()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        charityRef.removeAllObservers()
    }
    
    @IBAction func donateButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToDonation", sender: charity)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let charityObj: Charity = sender as? Charity else { return }
        guard let destinationVc: DonationViewController = segue.destination as? DonationViewController else{
            return
        }
        destinationVc.charity = charityObj
    }
}
