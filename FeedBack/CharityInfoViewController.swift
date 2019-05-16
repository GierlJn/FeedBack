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
        
        charityRef = ref.child(charityPath).child(charityId)
        
        infoLabel.text = "asdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsfdfasdfasdfadsf"
        infoLabel.preferredMaxLayoutWidth = 500
        infoLabel.numberOfLines = 0
        infoLabel.sizeToFit()
        
        
        //charityInfoBox.sizeToFit()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        charityRef.observe(DataEventType.value) { (snapshot) in
            self.charity = Charity(snapshot: snapshot)
            self.charityTitle.text = self.charity?.name
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
