
import UIKit

class DonationTableTableViewCell: UITableViewCell {

    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let identifier = "DonationTableTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure (for donation: Donation ){
        amountLabel.text = String(donation.amount) + currency
        recipientLabel.text = donation.name
        dateLabel.text = donation.getTimeStampAsString()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
}
