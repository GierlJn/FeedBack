import UIKit
import Firebase

class CharityInfoViewController: UIViewController {

    @IBOutlet weak var charityTitle: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    lazy var ref: DatabaseReference = Database.database().reference()
    var charityRef: DatabaseReference!
    var charityId = ""
    var charity: Charity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        charityRef = ref.child(charityPath).child(charityId)
        infoLabel.preferredMaxLayoutWidth = 500
        infoLabel.numberOfLines = 0
        infoLabel.layoutIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        charityRef.observe(DataEventType.value) { (snapshot) in
            self.charity = Charity(snapshot: snapshot)
            self.charityTitle.text = self.charity?.name
            self.infoLabel.text = self.charity?.about
            self.logoImageView.image = self.charity?.getLogoImage()
            self.infoLabel.sizeToFit()
        }
    }
    
    func downloadLogo(_ fileName: String){
        let storage: Storage = Storage.storage()
        let reference: StorageReference = storage.reference(forURL: "gs://feedback-cf3dc.appspot.com/" + fileName)
        reference.downloadURL { (url, error) in
            guard let imageUrl = url, error == nil else {
                print("Error: check Url")
                return
            }
            guard let data = NSData(contentsOf: imageUrl) else {
                print("Error: check Url")
                return
            }
            guard let image = UIImage(data: data as Data) else {
                return
            }
            self.logoImageView.image = image
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
