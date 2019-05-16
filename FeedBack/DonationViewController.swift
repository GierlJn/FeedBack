import UIKit

class DonationViewController: UIViewController {

    var charity: Charity?
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = charity!.name
    }
}
