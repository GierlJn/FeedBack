import UIKit
import Firebase

class CharityInfoViewController: UIViewController {

    @IBOutlet weak var charityTitle: UILabel!
    
    lazy var ref: DatabaseReference = Database.database().reference()
    
    var charityRef: DatabaseReference!
    var charityId = ""
    var charity: Charity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charityRef = ref.child(charityPath).child(charityId)
        
        //charityInfoBox.numberOfLines = 0
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
    

}
